import streamlit as st
from pathlib import Path
import pandas as pd

st.set_page_config(
    page_title="GA4 Business Analytics Dashboard",
    page_icon="📊",
    layout="wide"
)

st.title("GA4 Business Analytics Dashboard")

st.write("Welcome to the GA4 Business Analytics Dashboard")

st.subheader("Business KPIs")

col1, col2, col3 = st.columns(3)

kpi_df = pd.read_csv("data/kpi_data.csv")

total_revenue = kpi_df["total_revenue"].iloc[0]
purchasing_users = kpi_df["purchasing_users"].iloc[0]
total_purchases = kpi_df["total_purchases"].iloc[0]

col1.metric(
    "💰 Total Revenue",
    f"${total_revenue:,.0f}"
)

col2.metric(
    "👥 Purchasing Users",
    f"{purchasing_users:,.0f}"
)

col3.metric(
    "🛒 Total Purchases",
    f"{total_purchases:,.0f}"
)

#monthly revenue trend

st.subheader("Monthly Revenue Trend")
monthly_revenue_df = pd.read_csv("data/monthly_revenue.csv")

st.line_chart(
    monthly_revenue_df,
    x="month",
    y="monthly_revenue"
)           

# acquisition source 

st.subheader("Acquisition Source")
source_df = pd.read_csv("data/source_performance.csv")

st.dataframe(source_df)

st.bar_chart(
    source_df,
    x="source",
    y="revenue"
)

# revenue by devices

st.subheader("Revenue By Device")
device_df = pd.read_csv("data/revenue_by_device.csv")

st.bar_chart(
    device_df,
    x="device",
    y="revenue"
) 

# top products

st.subheader("Top Products")
products_df = pd.read_csv("data/top_products.csv")

st.dataframe(products_df)