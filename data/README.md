# Data

This repository includes small synthetic sample datasets for public portfolio use.

The original academic coursework datasets are not included. To run the scripts with private coursework data locally, place the CSV files in:

```text
data/private/
```

Expected private files:

- `data_amazon.csv`
- `data_product.csv`
- `data_sales.csv`
- `data_marketing.csv`

The scripts automatically use `data/private/` if the expected files are present; otherwise they use the public synthetic sample data.
