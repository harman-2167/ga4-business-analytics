from google.cloud import bigquery
import pandas as pd

#BigQuery Client
client = bigquery.Client()

# GA4 dataset
TABLE = "bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*"


# --------------------------------------------------
# 1. TOTAL REVENUE & PURCHASE KPIs
# --------------------------------------------------

query = f"""
SELECT
    SUM(ecommerce.purchase_revenue_in_usd) AS total_revenue,
    COUNT(DISTINCT user_pseudo_id) AS purchasing_users,
    COUNTIF(event_name = 'purchase') AS total_purchases
FROM `{TABLE}`
WHERE event_name = 'purchase'
"""
kpi_df = client.query(query).to_dataframe()

print("\n========== GA4 BUSINESS KPIs ==========")
print(kpi_df)