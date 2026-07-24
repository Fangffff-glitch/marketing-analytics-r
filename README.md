# Marketing Analytics in R

This repository contains a public portfolio version of marketing analytics work in R. It uses synthetic sample data to demonstrate campaign ROI analysis, predictive targeting, sales regression, and experimental design thinking.

The project is adapted from academic marketing analytics exercises and rewritten for portfolio use. Course briefs, candidate details, and university-provided datasets are not included.

## Business Questions

1. Should a company send a marketing offer to all customers, or target only customers with a high predicted response probability?
2. Which targeting model produces the strongest ROI: blanket marketing, a decision tree, or a random forest?
3. How do price, marketing spend, brand, and product characteristics relate to sales?
4. How should an A/B/n experiment be designed to evaluate website/chatbot improvements?

## Methods

- ROI and break-even response-rate calculation
- Train/test split for model evaluation
- Decision tree classification
- Random forest classification
- Probability-based targeting
- Linear regression for sales analysis
- Fixed-effects style controls using product attributes
- A/B/n experiment design summary

## Tools

- R
- rpart
- ranger
- ggplot2
- dplyr

## Repository Structure

```text
.
├── README.md
├── requirements.R
├── campaign_roi_targeting.R
├── sales_regression_analysis.R
├── data/
│   ├── campaign_sample.csv
│   └── tv_sales_sample.csv
└── outputs/
    └── .gitkeep
```

## How to Run

Install packages:

```r
source("requirements.R")
```

Run the campaign targeting analysis:

```bash
Rscript campaign_roi_targeting.R
```

Run the sales regression analysis:

```bash
Rscript sales_regression_analysis.R
```

## Portfolio Notes

This project demonstrates how marketing analytics can connect statistical modelling to commercial decisions. The emphasis is not only prediction accuracy, but also whether a model improves business outcomes such as campaign ROI, targeting efficiency, and decision interpretability.

