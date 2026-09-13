# Metric Glossary

| Metric | Definition | Formula / Source |
|---|---|---|
| Total Revenue | Revenue from purchase events. | `SUM(ecommerce.purchase_revenue)` |
| Purchase Events | Number of recorded `purchase` events. | `COUNTIF(event_name = 'purchase')` |
| Unique Transactions | Distinct valid transaction IDs. | `COUNT(DISTINCT ecommerce.transaction_id)` |
| Average Order Value | Average revenue per unique transaction. | Total Revenue / Unique Transactions |
| Active Users | Distinct users active during the analysis period. | `COUNT(DISTINCT user_pseudo_id)` |
| Sessions | Distinct user sessions. | Distinct `user_pseudo_id` + `ga_session_id` |
| Product Viewers | Users who viewed a product. | Distinct users with `event_name = 'view_item'` |
| Cart Users | Users who added an item to their cart. | Distinct users with `event_name = 'add_to_cart'` |
| Checkout Users | Users who began checkout. | Distinct users with `event_name = 'begin_checkout'` |
| Purchasing Users | Users with at least one purchase event. | Distinct users with `event_name = 'purchase'` |
| Funnel Conversion Rate | Product viewers who completed a purchase. | Purchasing Users / Product Viewers × 100 |
| Month-One Retention | New users returning in the following month. | Returning cohort users / Cohort users × 100 |