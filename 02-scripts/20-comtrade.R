library(ggplot2)
library(tidyr)
library(dplyr)

if (!dir.exists("03-plots/atpiec")) {
  dir.create("03-plots/atpiec")
}

name <- "pub"
name <- "mala"
title <- sprintf("%s CSV", name)
input_file <- sprintf("01-data/atpiec/csv/%s.csv", name)
output_file <- sprintf("03-plots/atpiec/20-%s_csv.pdf", name)

atpiec <- read.csv(input_file) |>
  rename(time_ms = T..ms.) |>
  filter(time_ms >= 0) |>
  mutate(time_us = time_ms * 1000) |>
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
  filter(time_ms < 50) |>
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
