# GA4 Business Analytics

Business Analytics project using the Google Analytics 4 (GA4) public ecommerce dataset.

## Tech Stack

* SQL (BigQuery)
* Python
* Pandas
* Matplotlib
* Plotly

## BigQuery Authentication

This project uses Google Cloud Application Default Credentials (ADC) to authenticate with BigQuery.

Credentials are configured locally and are **not stored in this repository**.

To verify the BigQuery connection:

```bash
python python/bigquery_connection.py
```

A successful connection will display:

```text
BigQuery connection successful: ga4-business-analytics
```

> **Security:** Never commit service-account keys, credential JSON files, API keys, or other sensitive credentials to GitHub.

## Status

Work in Progress
