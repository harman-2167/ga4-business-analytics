import streamlit as st
import plotly.express as px
import pandas as pd

st.set_page_config(
    page_title="GA4 Business Analytics Dashboard",
    page_icon="📈",
    layout="wide"
)

st.title("GA4 Business Analytics Dashboard")

st.markdown(
    "Interactive analysis of customer behavior, revenue, "
    "products, devices, and acquisition performance."
)

st.divider()

st.subheader("Business KPIs")
kpi_df = pd.read_csv("data/business_kpis.csv")

total_users = kpi_df["total_users"].iloc[0]
total_sessions = kpi_df["total_sessions"].iloc[0]
total_orders = kpi_df["total_orders"].iloc[0]
total_revenue = kpi_df["total_revenue"].iloc[0]

metrics_df = pd.read_csv("data/business_metrics.csv")

average_order_value = metrics_df["average_order_value"].iloc[0]
session_conversion_rate = metrics_df["session_conversion_rate"].iloc[0]

col1, col2, col3, col4, col5, col6 = st.columns(6)
col1.metric(
    "Total Users",
    f"{total_users:,.0f}"
)

col2.metric(
    "Total Sessions",
    f"{total_sessions:,.0f}"
)

col3.metric(
    "Total Orders",
    f"{total_orders:,.0f}"
)

col4.metric(
    "Total Revenue",
    f"${total_revenue:,.0f}"
)

col5.metric(
    "Average Order Value",
    f"${average_order_value:.2f}"
)

col6.metric(
    "Session Conversion Rate",
    f"{session_conversion_rate:.2f}%"
)

#monthly revenue trend

st.subheader("Monthly Revenue Trend")
monthly_revenue_df = pd.read_csv("data/monthly_revenue.csv")

st.line_chart(
    monthly_revenue_df,
    x="month",
    y="monthly_revenue"
)           

col1, col2 = st.columns(2)

with col1:

    st.subheader("Acquisition Source")

    source_df = pd.read_csv(
        "data/source_performance.csv"
    )

    st.bar_chart(
        source_df,
        x="source",
        y="revenue"
    )


with col2:

    st.subheader("Revenue By Device")

    device_df = pd.read_csv(
        "data/revenue_by_device.csv"
    )

    st.bar_chart(
        device_df,
        x="device",
        y="revenue"
    )

# top products

st.subheader("Top Products")
products_df = pd.read_csv("data/top_products.csv")

st.dataframe(products_df)

fig = px.bar (
    products_df,
    x= "revenue",
    y= "product_name",
    orientation= "h",
    title ="Top Product By Revenue",
    labels={
        "revenue": "Revenue ($)",
        "product_name": "Product"
    }
)

fig.update_layout(
    yaxis={"categoryorder": "total ascending"},
    height=500
)

st.plotly_chart(
    fig,
    use_container_width=True
)
st.subheader("Product Revenue Details")

st.dataframe(
    products_df,
    use_container_width=True,
    hide_index=True
)

# Customer Purchasing Funnel

funnel_df = pd.read_csv("data/funnel_data.csv")

funnel_data = pd.DataFrame({
    "Stage": [
        "View Item",
        "Add to Cart",
        "Begin Checkout",
        "Purchase"
    ],
    "Users": [
        funnel_df["product_viewers"].iloc[0],
        funnel_df["cart_users"].iloc[0],
        funnel_df["checkout_users"].iloc[0],
        funnel_df["purchasing_users"].iloc[0]
    ]
})

fig = px.funnel(
    funnel_data,
    x="Users",
    y="Stage",
    title="Customer Purchasing Funnel"
)

st.plotly_chart(
    fig,
    use_container_width=True
)

# business insights

st.subheader("Business Insights")
st.markdown("""
### Revenue Performance
The dashboard tracks overall revenue and monthly revenue trends
to identify periods of stronger and weaker business performance.

### Customer Purchasing Behavior
Purchasing users and total purchases help measure customer
engagement and purchasing activity.

### Device Performance
Revenue by device helps identify which device category
contributes the most to ecommerce revenue.

### Acquisition Performance
Acquisition source performance helps identify traffic sources
that generate stronger revenue and customer activity.
""")