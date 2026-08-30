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

st.subheader("Monthly Revenue Trend")

monthly_revenue_df = pd.read_csv("data/monthly_revenue.csv")

st.line_chart(
    monthly_revenue_df,
    x="month",
    y="monthly_revenue"
)
