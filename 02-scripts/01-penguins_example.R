library(ggplot2)

if (!dir.exists("03-plots")) {
  dir.create("03-plots")
}

read.csv("01-data/palmerpenguins.csv") |>
  ggplot(aes(bill_length_mm, bill_depth_mm)) +
  geom_point(na.rm = TRUE, color = "steelblue") +
  facet_wrap(~species, labeller = label_both) +
  labs(
    title = "Penguins bill depth by length",
    subtitle = "Per species",
    caption = "Built with R, palmerpenguins and ggplot2",
    x = "Bill length (mm)",
    y = "Bill depth (mm)",
  )

ggsave("03-plots/01-bill_lengh_by_bill_depth.pdf", width = 10, height = 5, units = "in")
