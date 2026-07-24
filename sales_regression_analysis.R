library(dplyr)
library(ggplot2)

private_product_path <- "data/private/data_product.csv"
private_sales_path <- "data/private/data_sales.csv"
private_marketing_path <- "data/private/data_marketing.csv"

if (
  file.exists(private_product_path) &&
  file.exists(private_sales_path) &&
  file.exists(private_marketing_path)
) {
  data_product <- read.csv(private_product_path)
  data_sales <- read.csv(private_sales_path)
  data_marketing <- read.csv(private_marketing_path)

  tv_sales <- data_sales %>%
    left_join(data_product, by = "product_id") %>%
    left_join(data_marketing, by = c("week_id", "brand")) %>%
    mutate(
      final_price = RRP * (1 - discount),
      units_sold = sales,
      screen_size = screensize,
      product_id = factor(product_id)
    )
} else {
  tv_sales <- read.csv("data/tv_sales_sample.csv") %>%
    mutate(product_id = factor(product_id))
}

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
controlled_summary <- summary(product_fixed_effects_model)
key_coefficients <- controlled_summary$coefficients[
  rownames(controlled_summary$coefficients) %in%
    c("(Intercept)", "final_price", "marketing_expense", "week_id"),
  ,
  drop = FALSE
]
print(key_coefficients)
print(
  data.frame(
    r_squared = controlled_summary$r.squared,
    adjusted_r_squared = controlled_summary$adj.r.squared,
    residual_standard_error = controlled_summary$sigma
  )
)

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
