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

# Which carrier has the worst average delays?

flights |>
  filter(dep_delay > 0) |>
  group_by(carrier) |>
  summarise(avg_dep_delay = mean(dep_delay)) |>
  arrange(desc(avg_dep_delay))

flights |>
  filter(!is.na(dep_delay)) |>
  group_by(carrier) |>
  summarise(avg_dep_delay = mean(dep_delay)) |>
  arrange(desc(avg_dep_delay))

# 3.5.7 Groups Exercise 2 ====

# Find the flights that are most delayed upon departure from each destination.

flights |>
  select(dest, dep_delay, flight) |>
  group_by(dest) |>
  slice_max(dep_delay, n = 1)

# 3.5.7 Groups Exercise 3 ====

# How do delays vary over the course of the day.
# Illustrate your answer with a plot.

if (!dir.exists("03-plots")) {
  dir.create("03-plots")
}

flights |>
  group_by(hour) |>
  summarise(avg_delay = mean(dep_delay, na.rm = TRUE)) |>
  ggplot(aes(hour, avg_delay)) +
  geom_smooth() +
  labs(
    title = "Average delay over the course of the day",
    subtitle = "Flights departed from NYC in 2013",
    caption = "Built with R, RStudio, nycflights13, dplyr and ggplot2",
    x = "Hour",
    y = "Average Delay",
  )

ggsave("03-plots/02-avg_delay_over_day.pdf", width = 10, height = 5, units = "in")

# 3.5.7 Groups Exercise 4 ====

# What happens if you supply a negative n to slice_min() and friends?
# slice_min(n = 3) -> 3 lowest
# slice_min(n = -3) -> all, but the 3 last, lowest

flights |>
  relocate(dest, dep_delay) |>
  group_by(dest) |>
  slice_min(dep_delay, n = -3, with_ties = FALSE)

# 3.5.7 Groups Exercise 5 ====

# Explain what count() does in terms of the dplyr verbs you just learned.
# What does the sort argument to count() do?

flights |>
  count(carrier, sort = TRUE)

# 3.5.7 Groups Exercise 6 ====

# Suppose we have the following tiny data frame:

df <- tibble(
  x = 1:5,
  y = c("a", "b", "a", "a", "b"),
  z = c("K", "K", "L", "L", "K")
)

# a) Write down what you think the output will look like,
# then check if you were correct, and describe what group_by() does.

df |>
  group_by(y)

# b) Write down what you think the output will look like,
# then check if you were correct, and describe what arrange() does.
# Also comment on how it’s different from the group_by() in part (a)?

df |>
  arrange(y)
# c) Write down what you think the output will look like,
# then check if you were correct, and describe what the pipeline does.

df |>
  group_by(y) |>
  summarize(mean_x = mean(x))

# d) Write down what you think the output will look like,
# then check if you were correct, and describe what the pipeline does.
# Then, comment on what the message says.

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

# e) Write down what you think the output will look like,
# then check if you were correct, and describe what the pipeline does.
# How is the output different from the one in part (d).

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x), .groups = "drop")

# f) Write down what you think the outputs will look like,
# then check if you were correct, and describe what each pipeline does.
# How are the outputs of the two pipelines different?

df |>
  group_by(y, z) |>
  summarize(mean_x = mean(x))

df |>
  group_by(y, z) |>
  mutate(mean_x = mean(x))

# 3.6 Groups Case Study aggregates and sample size ====

# Whenever you do any aggregation, it’s always a good idea to include a count (n()).
# That way, you can ensure that you’re not drawing conclusions based on very small amounts of data.

flights |>
  filter(dep_delay > 0) |>
  group_by(carrier) |>
  summarise(avg_delay = mean(dep_delay), entries = n()) |>
  # filter(entries > 9000) |>
  arrange(desc(avg_delay))
