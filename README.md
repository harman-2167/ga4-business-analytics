# GA4 Business Analytics

Business Analytics project using the **Google Analytics 4 (GA4) public ecommerce dataset**.

The project focuses on analyzing customer behavior, purchase funnels, traffic sources, product performance, sessions, and revenue to generate meaningful and actionable business insights.


## Tech Stack

* SQL (Google BigQuery)
* Python
* Pandas
* NumPy
* Matplotlib
* Plotly
* SciPy
* Streamlit


## BigQuery Authentication

This project uses **Google Cloud Application Default Credentials (ADC)** to authenticate with BigQuery.

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


# Business Understanding

The business understanding phase defines the business context, analytical direction, stakeholders, objectives, and success criteria for the project.

### Completed

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

```text
docs/01_business_understanding.md
```


# Data Understanding

The data understanding phase focuses on understanding the GA4 dataset, schema, structure, and event-based data model.

### Completed

* GA4 dataset overview
* GA4 schema analysis
* Dataset structure analysis
* Nested and repeated fields analysis
* Event-based data model analysis

Detailed documentation:

```text
docs/02_data_understanding.md
```


# SQL Analysis

SQL analysis is performed using **Google BigQuery** and is organized into separate analytical modules.

## 01. Data Overview

```text
sql/01_data_overview.sql
```

Analysis includes:

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


## 02. Event Analysis

```text
sql/02_event_analysis.sql
```

Analysis includes:

* Event frequency
* Event distribution
* Unique users per event
* Average events per user
* Average events per day
* Daily event trends


## 03. Customer Analysis

```text
sql/03_customer_analysis.sql
```

Analysis includes:

* Purchasing users
* Non-purchasing users
* Purchase count per customer
* One-time vs repeat customers
* Purchase frequency distribution
* Average purchases per customer
* Total revenue by customer
* Average revenue per customer
* Top customers by revenue


## 04. Funnel Analysis

```text
sql/04_funnel_analysis.sql
```

Analysis includes:

* Funnel users by stage
* Funnel conversion rates
* Overall purchase conversion rate
* Funnel drop-off analysis


## 05. Product Analysis

```text
sql/05_product_analysis.sql
```

Analysis includes:

* Product-level performance
* Top products by revenue
* Top products by quantity sold
* Revenue per unit


## 06. Revenue Analysis

```text
sql/06_revenue_analysis.sql
```

Analysis includes:

* Total revenue
* Revenue by date
* Monthly revenue trend
* Average order value
* Revenue by customer


## 07. Session Analysis

```text
sql/07_session_analysis.sql
```

Analysis includes:

* Total sessions
* Sessions by date
* Average sessions per user
* Average events per session
* Sessions by device
* Sessions by traffic source
* Sessions by country
* Session conversion to purchase


## 08. Traffic Source Analysis

```text
sql/08_traffic_source_analysis.sql
```

Analysis includes:

* Revenue by traffic source
* Traffic source performance
* Acquisition source performance
* Purchase rate by traffic source


## 09. Business Analysis

```text
sql/09_business_analysis.sql
```

Business analysis combines key metrics from different analytical areas to answer practical business questions.

Analysis includes:

* Business KPIs
* Revenue performance
* Revenue by device
* Revenue by traffic source
* Acquisition performance
* Customer purchasing behavior
* Product performance
* Purchase performance


# Data Quality Validation

Data quality validation is performed to ensure that the analytical results are reliable and consistent.

### Completed Validation Checks

* Missing value validation
* Duplicate value validation
* Event name validation
* Revenue validation
* Product/item validation
* Quantity validation
* Negative price validation
* Negative revenue validation
* Invalid quantity validation
* Missing product name validation
* Purchase item validation

The validation process also identifies abnormal product quantities and missing item-level attributes before using the data for deeper analysis.


# Python Analysis

Python is used to extract analytical results, process datasets, and create business visualizations.

Current Python workflow includes:

* BigQuery data extraction
* Pandas-based data processing
* CSV-based analytical outputs
* Matplotlib visualizations
* Business performance analysis

Main Python files:

```text
python/bigquery_connection.py
python/ga4_analysis.py
python/visualization.py
```


# Data Visualization

Python-based visualizations are developed using **Matplotlib**, **Plotly**, and **Streamlit**.

### Completed Visualizations

* Monthly Revenue Trend
* Top Products by Revenue
* Acquisition Source Performance
* Revenue by Device

Visualization outputs are stored in:

```text
screenshots/
```

### Interactive Dashboard

An interactive business analytics dashboard is being developed using **Streamlit**.

The dashboard provides:

* Business KPI overview
* Revenue performance
* Monthly revenue trend
* Top products by revenue
* Revenue by device
* Acquisition source performance
* Interactive business analysis



# Project Structure

```text
ga4-business-analytics/
│
├── data/
│   ├── monthly_revenue.csv
│   ├── top_products_by_revenue.csv
│   ├── acquisition_source_performance.csv
│   └── revenue_by_device.csv
│ 
├── dashboard/
│   └── app.py
│
├── docs/
│   ├── 01_business_understanding.md
│   └── 02_data_understanding.md
│
├── python/
│   ├── bigquery_connection.py
│   ├── ga4_analysis.py
│   └── visualization.py
│
├── sql/
│   ├── 01_data_overview.sql
│   ├── 02_event_analysis.sql
│   ├── 03_customer_analysis.sql
│   ├── 04_funnel_analysis.sql
│   ├── 05_product_analysis.sql
│   ├── 06_revenue_analysis.sql
│   ├── 07_session_analysis.sql
│   ├── 08_traffic_source_analysis.sql
│   ├── 09_business_analysis.sql
│   └── Data_cleaning.sql
|
├── screenshots/
│   ├── monthly_revenue_trend.png
│   ├── top_products_by_revenue.png
│   ├── acquisition_source_performance.png
│   └── revenue_by_device.png
│
├── README.md
└── requirements.txt
```


# Project Status

## Completed

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
* Session analysis
* Traffic source analysis
* Business analysis SQL
* Data quality validation
* Python analysis setup
* Initial business visualizations

## Current Phase

The project is currently focused on completing the **interactive Streamlit business analytics dashboard**.

Current work includes:

* Integrating analytical CSV outputs into Streamlit
* Adding interactive business visualizations
* Displaying key business KPIs
* Adding revenue performance analysis
* Adding device-level revenue analysis
* Adding acquisition source performance
* Validating dashboard results
* Improving dashboard presentation
* Preparing final business insights and recommendations


# Next Steps

* Complete the Streamlit dashboard
* Add remaining business visualizations
* Validate dashboard metrics against SQL results
* Customer segmentation
* Retention and cohort analysis
* Data dictionary
* Advanced business analytics
* Business insights
* Business recommendations
* Final project documentation
* Final GitHub cleanup and presentation



# Project Goal

The goal of this project is to transform raw **GA4 ecommerce event data** into meaningful business insights.

The analysis helps stakeholders:

* Understand customer behavior
* Identify purchase funnel bottlenecks
* Evaluate acquisition channels
* Analyze product performance
* Understand device-level revenue performance
* Identify valuable customer segments
* Monitor revenue trends
* Discover opportunities for business growth

Ultimately, the project aims to move from **raw event data → analytical insights → business recommendations**.
