library(dplyr)
library(ggplot2)

tv_sales <- read.csv("data/tv_sales_sample.csv")

basic_model <- lm(
  units_sold ~ final_price + marketing_expense + brand,
  data = tv_sales
)

product_fixed_effects_model <- lm(
  units_sold ~ final_price + marketing_expense + product_id + week_id,
  data = tv_sales
)

print("Basic sales regression")
print(summary(basic_model))

print("Regression with product-level controls")
print(summary(product_fixed_effects_model))

ggplot(tv_sales, aes(x = final_price, y = units_sold, colour = brand)) +
  geom_point(size = 2) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(
    title = "TV Unit Sales and Final Price",
    x = "Final price",
    y = "Units sold"
  ) +
  theme_minimal()

ggsave("outputs/tv_price_sales_relationship.pdf", width = 8, height = 5, device = "pdf")

experiment_design <- data.frame(
  component = c(
    "Control",
    "Treatment A",
    "Treatment B",
    "Treatment C",
    "Randomisation unit",
    "Primary metrics",
    "Analysis approach"
  ),
  recommendation = c(
    "Existing chat box placement and current chatbot model",
    "Improved chat box visibility",
    "Upgraded chatbot model",
    "Improved visibility plus upgraded chatbot model",
    "User-level randomisation, with each user consistently assigned to one condition to avoid crossover",
    "Chat click-through rate, chat initiation rate, resolution rate, satisfaction score, escalation rate",
    "Compare treatment and control groups with t-tests, proportion tests, or regression with treatment indicators"
  )
)

print("A/B/n experiment design summary")
print(experiment_design)

write.csv(experiment_design, "outputs/abn_experiment_design.csv", row.names = FALSE)
