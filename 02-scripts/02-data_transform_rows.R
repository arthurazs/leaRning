library(nycflights13)
library(dplyr)
library(ggplot2)

# 3.2.5 Rows Exercise 1 ====

thirty_minutes <- 30
one_hour <- thirty_minutes * 2
two_hours <- 2 * one_hour
houston <- c("IAH", "HOU")
summer <- c(7, 8, 9)

flights |>
  filter(
    arr_delay >= two_hours,
    dest %in% houston,
    carrier %in% c("UA", "AA", "DL"),
    month %in% summer,
  )

flights |>
  filter(
    arr_delay > two_hours,
    dep_delay <= 0,
  )

flights |>
  filter(dep_delay >= one_hour, air_time > thirty_minutes)

# 3.2.5 Rows Exercise 2 ====

flights |>
  arrange(desc(dep_delay))

flights |>
  arrange(dep_time)

# 3.2.5 Rows Exercise 3 ====

flights |>
  arrange(arr_time - dep_time)

# 3.2.5 Rows Exercise 4 ====

flights |>
  count(month, day)

# 3.2.5 Rows Exercise 5 ====
flights |>
  arrange(desc(distance))

flights |>
  arrange(distance)
