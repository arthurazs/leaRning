library(ggplot2)
library(tidyr)
library(dplyr)

if (!dir.exists("03-plots")) {
  dir.create("03-plots")
}

atpiec <- read.csv("01-data/REGUAS_BJDLAPA.csv") |>
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
  filter(time_ms < 25) |>
  ggplot(aes(time_ms, measurement, color = phase)) +
  geom_line() +
  # geom_point() +
  facet_wrap(
    ~type,
    ncol = 1,
    scales = "free_y",
    strip.position = "left",
    labeller = as_labeller(c(I = "Current (A)", V = "Voltage (V)")),
  ) +
  labs(
    title = "ATP-generated CSV",
    x = "Time (ms)",
    color = "Phase",
  ) +
  ylab(NULL) +
  theme(
    strip.background = element_blank(),
    strip.placement = "outside",
  )

ggsave("03-plots/98-atp_csv.pdf", width = 10, height = 5, units = "in")
