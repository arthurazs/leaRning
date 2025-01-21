library(ggplot2)
library(tidyr)
library(dplyr)

plot_type <- "pcap"

input_path <- sprintf("01-data/atpiec/%s", plot_type)
output_path <- "03-plots/atpiec"

if (!dir.exists("03-plots")) {
  dir.create("03-plots")
}

if (!dir.exists(output_path)) {
  dir.create(output_path)
}

names <- c("2024-05-07exp1", "2024-05-07exp2")
for (name in names) {
  # range_start_ms <- 718.5
  # range_val_ms <- 250
  title <- sprintf("[%s] %s", plot_type, name)
  input_file <- sprintf("%s/%s.csv", input_path, name)
  output_file <- sprintf("%s/02-%s_%s.pdf", output_path, plot_type, name)

  atp <- read.csv(input_file) |>
    rename(time_us = T..us.) |>
    filter(time_us >= 0) |>
    mutate(time_ms = time_us / 1000) |>
    mutate(time_s = time_ms / 1000) |>
    relocate(time_us, time_ms, time_s)

  melted <- atp |>
    pivot_longer(
      cols = !time_us:time_s,
      names_to = c("type", "phase", "input"),
      names_sep = c(1, 2, 3),
      values_to = "measurement",
    )

  melted <- melted |>
    mutate(measurement = if_else(type == "I", measurement, measurement / 1000))

  melted |>
    # filter(time_ms < range_start_ms + range_val_ms, time_ms >= range_start_ms) |>
    ggplot(aes(time_ms, measurement, color = phase)) +
    coord_cartesian(xlim = c(718, 968)) +
    # scale_x_continuous(breaks = c(718, 768, 800, 818, 868, 918, 968)) +
    scale_x_continuous(breaks = c(750, 800, 850, 900, 950)) +
    geom_line() +
    # geom_point() +
    facet_wrap(
      ~type,
      ncol = 1,
      scales = "free_y",
      strip.position = "left",
      labeller = as_labeller(c(I = "Current (A)", V = "Voltage (kV)")),
    ) +
    labs(
      title = title,
      x = "Time (ms)",
      color = "Phase",
    ) +
    ylab(NULL) +
    theme(
      strip.background = element_blank(),
      strip.placement = "outside",
    )

  ggsave(output_file, width = 10, height = 5, units = "in")
}
