library(nycflights13)
library(dplyr)
library(ggplot2)

# 3.2.5 Rows Exercise 1 ====

THIRTY_MINUTES <- 30
ONE_HOUR <- THIRTY_MINUTES * 2
TWO_HOURS <- 2 * ONE_HOUR
HOUSTON <- c("IAH", "HOU")
SUMMER <- c(7, 8, 9)

flights |>
  filter(
    arr_delay >= TWO_HOURS,
    dest %in% HOUSTON,
    carrier %in% c("UA", "AA", "DL"),
    month %in% SUMMER,
  )

flights |>
  filter(
    arr_delay > TWO_HOURS,
    dep_delay <= 0,
  )

flights |>
  filter(dep_delay >= ONE_HOUR, air_time > THIRTY_MINUTES)

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