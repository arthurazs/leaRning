library(nycflights13)
library(dplyr)
library(ggplot2)

# 3.4 Columns Study ====

flights |> 
  mutate(
    delay_gain = dep_delay - arr_delay,
    speed_mph = distance / air_time * 60,
    .keep = "used"
  )

flights |> 
  select(where(is.character))

flights |> 
  select(year:day)

flights |> 
  select(!year:day)

flights |>
  select(day, Hour = hour, Minute = minute, time_hour)

flights |> 
  relocate(year:dep_time, .after = time_hour)

flights |> 
  relocate(starts_with("arr"), .before = dep_time)

flights |> 
  filter(dest == "IAH") |> 
  mutate(speed = distance / air_time * 60) |> 
  select(year:day, dep_time, carrier, flight, speed) |> 
  arrange(desc(speed))

# 3.3.5 Columns Exercise 1 ====

flights |>
  select(dep_time, sched_dep_time, dep_delay)

# 3.3.5 Columns Exercise 2 ====

flights |>
  select(dep_time, dep_delay, arr_time, arr_delay)

flights |>
  select(dep_time:arr_delay, -starts_with("sched"))

flights |>
  select(starts_with("dep_"), starts_with("arr_"))

# 3.3.5 Columns Exercise 3 ====

flights |>
  select(dep_time, dep_time)

flights |>
  select(dep1 = dep_time, dep2 = dep_time)

# 3.3.5 Columns Exercise 4 ====

variables <- c("year", "month", "day", "dep_delay", "arr_delay", "error")
flights |>
  select(any_of(variables))

# 3.3.5 Columns Exercise 5 ====

flights |>
  select(contains("TIME"))

flights |>
  select(contains("TIME", ignore.case = FALSE))

# 3.3.5 Columns Exercise 6 ====

flights |>
  rename(air_time_min = air_time) |>
  relocate(air_time_min)
