library(dplyr)
library(rpart)
library(ranger)
library(ggplot2)

set.seed(888)

data <- read.csv("data/campaign_sample.csv")

offer_cost <- 2.00
profit_per_subscription <- 35.00
break_even_response_rate <- offer_cost / profit_per_subscription

calculate_roi <- function(probability, actual, threshold, offer_cost, profit_per_subscription) {
  targeted <- probability >= threshold
  revenue <- sum(actual[targeted] * profit_per_subscription)
  cost <- sum(targeted) * offer_cost

  if (cost == 0) {
    return(0)
  }

  (revenue - cost) / cost
}

blanket_roi <- calculate_roi(
  probability = rep(1, nrow(data)),
  actual = data$subscribe,
  threshold = 0.5,
  offer_cost = offer_cost,
  profit_per_subscription = profit_per_subscription
)

train_index <- sample(seq_len(nrow(data)), size = floor(0.7 * nrow(data)))
data_training <- data[train_index, ]
data_test <- data[-train_index, ]

tree_model <- rpart(
  subscribe ~ recency + frequency + monetary_value,
  data = data_training,
  method = "class",
  control = rpart.control(cp = 0.001, minsplit = 4)
)

tree_probability <- predict(tree_model, data_test, type = "prob")[, "1"]
tree_roi <- calculate_roi(
  probability = tree_probability,
  actual = data_test$subscribe,
  threshold = break_even_response_rate,
  offer_cost = offer_cost,
  profit_per_subscription = profit_per_subscription
)

forest_model <- ranger(
  subscribe ~ recency + frequency + monetary_value,
  data = transform(data_training, subscribe = factor(subscribe)),
  num.trees = 500,
  probability = TRUE,
  seed = 888
)

forest_probability <- predict(forest_model, data_test)$predictions[, "1"]
forest_roi <- calculate_roi(
  probability = forest_probability,
  actual = data_test$subscribe,
  threshold = break_even_response_rate,
  offer_cost = offer_cost,
  profit_per_subscription = profit_per_subscription
)

roi_results <- data.frame(
  strategy = c("Blanket marketing", "Decision tree targeting", "Random forest targeting"),
  roi = c(blanket_roi, tree_roi, forest_roi)
)

print("Break-even response rate")
print(round(break_even_response_rate, 4))

print("ROI comparison")
print(roi_results)

ggplot(roi_results, aes(x = reorder(strategy, roi), y = roi)) +
  geom_col(fill = "#4C78A8") +
  coord_flip() +
  labs(
    title = "Campaign ROI by Targeting Strategy",
    x = "Strategy",
    y = "ROI"
  ) +
  theme_minimal()

ggsave("outputs/campaign_roi_comparison.pdf", width = 8, height = 5, device = "pdf")

targeting_recommendations <- data_test %>%
  mutate(
    tree_probability = tree_probability,
    forest_probability = forest_probability,
    target_decision_tree = tree_probability >= break_even_response_rate,
    target_random_forest = forest_probability >= break_even_response_rate
  ) %>%
  select(
    customer_id,
    subscribe,
    tree_probability,
    forest_probability,
    target_decision_tree,
    target_random_forest
  )

write.csv(targeting_recommendations, "outputs/targeting_recommendations.csv", row.names = FALSE)

best_strategy <- roi_results$strategy[which.max(roi_results$roi)]
print(paste("Recommended strategy:", best_strategy))
