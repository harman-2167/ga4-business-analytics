import pandas as pd 
import matplotlib.pyplot as plt

print("GA4 Visualization Started...")

# --------------------------------------------------
# 1. MONTHLY REVENUE TREND
# --------------------------------------------------

monthly_revenue_df = pd.read_csv("data/monthly_revenue.csv")
print(monthly_revenue_df)

plt.figure(figsize=(10,5))

plt.plot(
    monthly_revenue_df['month'],
    monthly_revenue_df['monthly_revenue'],
    marker = 'o',
    
)
plt.title("monthly_revenue_trend")
plt.xlabel("month")
plt.ylabel("monthly_revenue")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("screenshots/monthly_revenue_trend.png")
plt.show()


# --------------------------------------------------
# 2. TOP PRODUCTS BY REVENUE
# --------------------------------------------------

products_df = pd.read_csv("data/top_products.csv")
print(products_df)

plt.figure(figsize=(10,6))

plt.bar(
    products_df['product_name'].head(10),
    products_df['revenue'].head(10)
)
plt.title("Top 10 Products by Revenue")
plt.xlabel("Product Name")
plt.ylabel("Revenue [USD]")
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig("screenshots/top_products_by_revenue.png")
plt.show()


# --------------------------------------------------
# 3. ACQUISITION SOURCE PERFORMANCE
# --------------------------------------------------

source_df = pd.read_csv("data/source_performance.csv")
print(source_df)

plt.figure(figsize=(10,6))
plt.bar(
    source_df['source'].head(10),
    source_df['revenue'].head(10)
) 
plt.title("Revenue by Acquisition Source")
plt.xlabel("Source")
plt.ylabel("Revenue [USD]")
plt.xticks(rotation=45, ha='right')
plt.tight_layout()
plt.savefig("screenshots/acquisition_source_performance.png")
plt.show()

# --------------------------------------------------
# 4. REVENUE BY DEVICE
# --------------------------------------------------

device_df = pd.read_csv("data/revenue_by_device.csv")

print("\nRevenue by Device:")
print(device_df)

plt.figure(figsize=(8, 5))

plt.bar(
    device_df["device"],
    device_df["revenue"]
)

plt.title("Revenue by Device")
plt.xlabel("Device")
plt.ylabel("Revenue (USD)")

plt.tight_layout()

plt.savefig("screenshots/revenue_by_device.png")

plt.show()