library(ggplot2)
library(tidyr)
library(dplyr)

input_path <- "01-data/atpiec/csv"
output_path <- "03-plots/atpiec"

if (!dir.exists("03-plots")) {
  dir.create("03-plots")
}

if (!dir.exists(output_path)) {
  dir.create(output_path)
}

# name <- "pub"
for (name in list("pub", "mala")) {4588.165
  if (name == "pub") { range_start_ms <- 4109.968} else { range_start_ms <- 1414.793 }
  range_val_ms <- 20
  title <- sprintf("%s PCAP", name)
  input_file <- sprintf("%s/%s_pcap.csv", input_path, name)
  output_file <- sprintf("%s/21-%s_pcap.pdf", output_path, name)
  
  atpiec <- read.csv(input_file) |>
    rename(time_us = T..us.) |>
    filter(time_us >= 0) |>
    mutate(time_ms = time_us / 1000) |>
    mutate(time_s = time_ms / 1000) |>
    relocate(time_us, time_ms, time_s)
  
  melted <- atpiec |>
    pivot_longer(
      cols = !time_us:time_s,
      names_to = c("type", "phase", "input"),
      names_sep = c(1, 2, 3),
      values_to = "measurement",
    )
  
  melted |>
    filter(time_ms < range_start_ms + range_val_ms, time_ms >= range_start_ms) |>
    ggplot(aes(time_ms, measurement, color = phase)) +
    geom_line() +
    geom_point() +
    facet_wrap(
      ~type,
      ncol = 1,
      scales = "free_y",
      strip.position = "left",
      labeller = as_labeller(c(I = "Current (A)", V = "Voltage (V)")),
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