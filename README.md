# GA4 Business Analytics

Business Analytics project using the Google Analytics 4 (GA4) public ecommerce dataset.

The project focuses on analyzing customer behavior, purchase funnels, traffic sources, products, and revenue to generate actionable business insights.

## Tech Stack

* SQL (BigQuery)
* Python
* Pandas
* NumPy
* Matplotlib
* Plotly
* SciPy

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

## Business Understanding

The business understanding phase defines the business context and analytical direction of the project.

Completed:

* Business scenario
* Business problem
* Stakeholder analysis
* Business objectives
* Success metrics
* KPI framework
* Project scope
* Assumptions
* Business questions

Detailed documentation:

`docs/01_business_understanding.md`

## Data Understanding

The data understanding phase focuses on the GA4 dataset structure and schema.

Completed:

* GA4 dataset overview
* GA4 schema analysis
* Dataset structure analysis
* Nested and repeated fields analysis
* Event-based data model analysis

Detailed documentation:

`docs/02_data_understanding.md`

## SQL Analysis

SQL analysis is performed using Google BigQuery and is organized into separate analytical modules.

### Data Overview

* Dataset verification
* Total events
* Total users
* Total days
* Dataset date range
* Total sessions
* Total purchases
* Total page views
* New and returning users
* Dataset size summary

`sql/01_data_overview.sql`

### Event Analysis

* Event frequency
* Event distribution
* Unique users per event
* Average events per user
* Average events per day
* Daily event trend

`sql/02_event_analysis.sql`

### Customer Analysis

* Purchasing users
* Non-purchasing users
* Purchase count per customer
* One-time vs repeat customers
* Purchase frequency distribution
* Average purchases per customer
* Total revenue by customer
* Average revenue per customer
* Top customers by revenue

`sql/03_customer_analysis.sql`

### Funnel Analysis

* Funnel users by stage
* Funnel conversion rates
* Overall purchase conversion rate
* Funnel drop-off analysis

`sql/04_funnel_analysis.sql`

### Product Analysis

* Product-level analysis
* Top products by revenue
* Top products by quantity sold
* Revenue per unit

`sql/05_product_analysis.sql`

### Revenue Analysis

* Total revenue
* Revenue by date
* Monthly revenue trend
* Average order value
* Revenue by customer

`sql/06_revenue_analysis.sql`

### Session Analysis

* Total sessions
* Sessions by date
* Average sessions per user
* Average events per session
* Sessions by device
* Sessions by traffic source
* Sessions by country
* Session conversion to purchase

`sql/07_session_analysis.sql`

### Traffic Source Analysis

* Revenue by traffic source
* Traffic source performance
* Acquisition source performance
* Purchase rate by traffic source

`sql/08_traffic_source_analysis.sql`

## Data Visualization

Python-based visualizations will be created using Matplotlib and Plotly after the core SQL analysis is completed.

Planned visualizations include:

* Funnel conversion visualization
* Customer purchase behavior
* Revenue trends
* Traffic source performance
* Top products by revenue
* Top products by quantity
* Customer segments

## Project Structure

```text
ga4-business-analytics/
│
├── docs/
│   ├── 01_business_understanding.md
│   └── 02_data_understanding.md
│
├── python/
│   ├── bigquery_connection.py
│   ├── analysis.py
│   └── visualization.py
│
├── sql/
│   ├── 01_data_overview.sql
│   ├── 02_event_analysis.sql
│   ├── 03_customer_analysis.sql
│   ├── 04_funnel_analysis.sql
│   ├── 05_product_analysis.sql
│   ├── 06_revenue_analysis.sql
|   |── 07_session_analysis.sql
│   └── 08_traffic_source_analysis.sql
|   
│
├── screenshots/
│
├── README.md
└── requirements.txt
```

## Project Status

**Work in Progress**

### Completed

### Completed

* BigQuery authentication and connection
* GA4 dataset verification
* Business understanding
* Data understanding
* GA4 schema analysis
* Dataset structure analysis
* Nested and repeated fields analysis
* Event-based data model analysis
* Dataset overview analysis
* Event analysis
* Customer analysis
* Funnel analysis
* Product analysis
* Revenue analysis

### Next Steps

* Traffic source analysis
* Complete and validate remaining SQL analysis modules
* Customer segmentation
* Retention and cohort analysis
* Data dictionary
* Python-based deeper analysis
* Data visualization
* Advanced business analytics
* Business insights
* Business recommendations
* Final project documentation

## Project Goal

The goal of this project is to transform raw GA4 ecommerce event data into meaningful business insights that can help stakeholders understand customer behavior, identify funnel bottlenecks, evaluate acquisition channels, analyze product performance, and improve revenue performance.
