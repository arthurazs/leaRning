library(tidyverse)

table1 <- tibble(
  country = c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China"),
  year = c(1999, 2000, 1999, 2000, 1999, 2000),
  cases = c(745, 2666, 37737, 80488, 212258, 213766),
  population = c(19987071, 20595360, 172006362, 174504898, 1272915272, 1280428583),
)

table2 <- tibble(
  country = c(
    "Afghanistan", "Afghanistan", "Afghanistan", "Afghanistan", "Brazil", "Brazil", "Brazil", "Brazil", "China",
    "China", "China", "China"
  ),
  year = c(1999, 1999, 2000, 2000, 1999, 1999, 2000, 2000, 1999, 1999, 2000, 2000),
  type = c(
    "cases", "population", "cases", "population", "cases", "population", "cases", "population", "cases", "population",
    "cases", "population"
  ),
  count = c(745, 19987071, 2666, 20595360, 37737, 172006362, 80488, 174504898, 212258, 1272915272, 213766, 1280428583),
)

table3 <- tibble(
  country = c("Afghanistan", "Afghanistan", "Brazil", "Brazil", "China", "China"),
  year = c(1999, 2000, 1999, 2000, 1999, 2000),
  rate = c(
    "745/19987071", "2666/20595360", "37737/172006362", "80488/174504898", "212258/1272915272", "213766/1280428583"
  ),
)

# 5 Data tidying ====

table1 |>
  group_by(country, year) |>
  summarise(sum(cases), .groups = "drop")

table1 |>
  ggplot(aes(x = year, y = cases)) +
  geom_line(aes(color = country)) +
  scale_x_continuous(breaks = c(1999, 2000)) # x-axis breaks at 1999 and 2000

# 5.2.1 Tidying Exercise 2 ====

# Sketch out the process you’d use to calculate the rate for table2 and table3.
# You will need to perform four operations:
# a) Extract the number of TB cases per country per year.
# b) Extract the matching population per country per year.
# c) Divide cases by population, and multiply by 10000.
# d) Store back in the appropriate place.

table2 |>
  pivot_wider(
    names_from = type,
    values_from = count
  ) |>
  mutate(rate = cases / population * 10000)

table3 # ???

# 5.3 Lengthening data ====

pivoted_billboard <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE,
  ) |>
  mutate(week = parse_number(week))

pivoted_billboard |>
  filter(artist == "Jay-Z") |>
  ggplot(aes(week, rank, color = track)) +
  geom_line() +
  scale_y_reverse()

# Tracks with the highest rank (1 best, 100 worst)
pivoted_billboard |>
  group_by(track) |>
  summarise(avg_rank = mean(rank), entries = n()) |>
  arrange(avg_rank, desc(entries))

# Tracks that stayed longer on the Billboard
pivoted_billboard |>
  distinct(artist, track, week) |>
  count(track, sort = TRUE)

# Artists with the most songs on the Billboard
pivoted_billboard |>
  distinct(artist, track) |>
  count(artist, sort = TRUE)

# 5.4  Widening data ====

cms_patient_experience |>
  pivot_wider(
    id_cols = starts_with("org_"),
    names_from = measure_cd,
    values_from = prf_rate,
  )

df <- tribble(
  ~id, ~measurement, ~value,
  "A",        "bp1",    100,
  "B",        "bp1",    140,
  "B",        "bp2",    115,
  "A",        "bp2",    120,
  "A",        "bp3",    105
)

df |>
  pivot_wider(
    # id_cols = id,  # not necessary in this case, might be in other cases
    names_from = measurement,
    values_from = value
  )
