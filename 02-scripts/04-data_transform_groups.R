library(nycflights13)
library(dplyr)
library(ggplot2)

# 3.5.2 Groups summarise ====

flights |> 
  filter(!is.na(dep_delay)) |> 
  group_by(month) |> 
  summarise(avg_dep_delay = mean(dep_delay))

flights |> 
  group_by(month) |> 
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    entries = n(),
  )

flights |> 
  filter(dep_delay > 0) |> 
  group_by(month) |> 
  summarise(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE),
    entries = n(),
  )

# 3.5.3 Groups slice ====

flights |> 
  relocate(dest, arr_delay) |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 1, with_ties = FALSE)

flights |> 
  relocate(dest, arr_delay) |> 
  group_by(dest) |> 
  slice_max(arr_delay, n = 2)

# 3.5.4 Groups multiple variables ====

flights |>  
  group_by(year, month, day) |>
  summarise(entries = n(), .groups = "drop_last")  # summarise defaults to drop_last

flights |>  
  group_by(year, month, day) |>
  slice_min(dep_time, n = 1, with_ties = FALSE)  # does not drop

# 3.5.5 Groups ungroup ====

flights |>  
  group_by(year, month, day) |>
  ungroup() |> 
  summarise(avg_dep_delay = mean(dep_delay, na.rm = TRUE), entries = n())

# 3.5.6 Groups .by ====

flights |> 
  group_by(month) |> 
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE), 
    entries = n(),
  )

flights |> 
  summarize(
    avg_dep_delay = mean(dep_delay, na.rm = TRUE), 
    entries = n(),
    .by = month
  ) |> 
  arrange(month)

flights |> 
  summarize(
    delay = mean(dep_delay, na.rm = TRUE), 
    n = n(),
    .by = c(origin, dest)
  )

# 3.5.7 Groups Exercise 1 ====

# https://r4ds.hadley.nz/data-transform#exercises-2