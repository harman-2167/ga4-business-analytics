# GA4 E-commerce Business Analytics

End-to-end ecommerce analytics project built using the Google Analytics 4 public ecommerce dataset. The project uses BigQuery SQL, Python, and Streamlit to analyse customer behaviour, revenue, conversion funnels, traffic sources, products, devices, and user retention.

## Overview

This project converts raw GA4 event-level data into business insights and recommendations.

The analysis answers questions such as:

- How much revenue was generated?
- Which products and acquisition channels perform best?
- Where do users drop off in the purchase funnel?
- Which device categories generate the most revenue?
- Do newly acquired users return in the following month?
- What actions can improve conversion, retention, and revenue?

## Tools and Technologies

- Google BigQuery
- SQL
- Python
- Pandas
- NumPy
- Matplotlib
- Plotly
- Streamlit
- Git and GitHub

## Dataset

Source table:

```text
bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
Dataset period:
November 2020 to December 2020
The dataset contains GA4 event-level ecommerce data, including:
- User and session identifiers
- Events such as view_item, add_to_cart, begin_checkout, and purchase
- Traffic-source attributes
- Device and geographic information
- Product and ecommerce transaction fields

Key Findings
Metric	Result
Total Revenue	$304,815.00
Unique Transactions	3,563
Average Order Value	$70.27
November First-Time Users	79,421
Users Returning in December	4,651
Month-One Retention	5.86%


Funnel Performance
Sessions:          267,116
Product Views:      61,252
Add-to-Cart Users:  12,545
Purchasing Users:    4,419

The main conversion opportunities are:
1. Improving product discovery to increase product views.
2. Reducing cart and checkout friction to increase completed purchases.
3. Improving mobile shopping and checkout experience.
4. Increasing return visits through retention campaigns.

Business Recommendations
- Improve site search, navigation, category pages, and product recommendations.
- Optimise cart and checkout flow to reduce drop-off.
- Focus marketing investment on high-revenue acquisition channels.
- Improve mobile speed, usability, and checkout experience.
- Use bundles, cross-selling, and upselling to increase average order value.
- Use email campaigns, remarketing, and abandoned-cart reminders to improve retention.

Data Quality Checks
The project includes SQL checks for:
- Daily event volume
- Missing or invalid purchase records
- Duplicate transaction IDs
- Revenue and order reconciliation

Key observations:
- 173 purchase events had missing or invalid transaction IDs or missing/non-positive revenue.
- (not set) appeared 583 times as a transaction ID and is treated as a placeholder rather than a valid transaction.
- Some valid transaction IDs occurred more than once; transaction-level analysis therefore uses distinct valid transaction IDs where appropriate.


Project Structure
ga4-business-analytics/
├── dashboard/
│   └── app.py
├── data/
│   ├── business_kpis.csv
│   ├── business_metrics.csv
│   ├── funnel_data.csv
│   ├── monthly_revenue.csv
│   ├── revenue_by_device.csv
│   ├── source_performance.csv
│   └── top_products.csv
├── docs/
│   ├── 01_business_understanding.md
│   ├── 02_Data_Understanding.md
│   ├── 03_Business_Insights.md
│   ├── 04_Metric_Glossary.md
│   └── 05_Data_Limitations.md
├── python/
│   ├── bigquery_connection.py
│   ├── ga4_analysis.py
│   └── visualisation.py
├── screenshots/
│   ├── acquisition_source_performance.png
│   ├── monthly_revenue_trend.png
│   ├── revenue_by_device.png
│   └── top_products_by_revenue.png
├── sql/
│   ├── 00_data_cleaning.sql
|   ├── 01_data_overview.sql
│   ├── 02_event_analysis.sql
│   ├── 03_customer_analysis.sql
│   ├── 04_funnel_analysis.sql
│   ├── 05_product_analysis.sql
│   ├── 06_revenue_analysis.sql
│   ├── 07_session_analysis.sql
│   ├── 08_retention_cohort_analysis.sql
│   ├── 09_Business_analysis.sql
│   └── 10_data_quality_checks.sql 
├── requirements.txt
├── .gitignore
└── README.md

SQL Analysis
File	Purpose
01_data_overview.sql	Dataset overview and baseline metrics
02_event_analysis.sql	Event-level user behaviour
03_customer_analysis.sql	Customer and purchasing analysis
04_funnel_analysis.sql	Purchase funnel and conversion analysis
05_product_analysis.sql	Product revenue and performance
06_revenue_analysis.sql	Revenue, orders, and average order value
07_session_analysis.sql	Session and traffic-source analysis
08_retention_cohort_analysis.sql	Monthly cohort retention analysis
09_Business_analysis.sql	Consolidated business analysis
10_data_quality_checks.sql	Data validation and quality checks


Dashboard
The Streamlit dashboard includes:
- KPI summary
- Monthly revenue trend
- Revenue by acquisition source
- Revenue by device
- Top products by revenue
- Customer purchase funnel
- Business recommendations

Run the dashboard locally:
streamlit run dashboard\app.py

Open the dashboard at:
http://localhost:8501

Setup
Clone the repository
git clone <YOUR_REPOSITORY_URL>
cd ga4-business-analytics

Create and activate a virtual environment
python -m venv .venv
.\.venv\Scripts\Activate.ps1

Install dependencies
python -m pip install -r requirements.txt

Verify BigQuery connection
python python\bigquery_connection.py

Run the dashboard
streamlit run dashboard\app.py

Screenshots
Monthly Revenue Trend
screenshots/monthly_revenue_trend.png

Acquisition Source Performance
screenshots/acquisition_source_performance.png

Revenue by Device
screenshot/revenue_by_device.png

Top Products by Revenue
screenshot/top_products_by_revenue.png

Documentation
- [Business Understanding](docs/01_business_understanding.md)
- [Data Understanding](docs/02_Data_Understanding.md)
- [Business Insights](docs/03_Business_Insights.md)
- [Metric Glossary](docs/04_Metric_Glossary.md)
- [Data Limitations](docs/05_Data_Limitations.md)

Limitations
- The dataset covers only November and December 2020.
- GA4 user identifiers represent browsers or devices and may not represent one individual across multiple devices.
- Ad blockers, cookie consent, and tracking issues can affect event capture.
- Attribution in GA4 may differ from advertising-platform reports.
- The available date range supports only month-one retention analysis.

Future Improvements
- RFM customer segmentation
- Customer lifetime value analysis
- Retention cohort heatmap
- Marketing attribution analysis
- Automated tests and GitHub Actions workflow

## Author
Harmandeep Kaur