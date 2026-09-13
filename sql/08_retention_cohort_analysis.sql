
## RETENTION COHORT ANALYSIS

WITH user_first_activity AS (
  SELECT
    user_pseudo_id,
    DATE_TRUNC(
      MIN(PARSE_DATE('%Y%m%d', event_date)),
      MONTH
    ) AS cohort_month
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201231'
  GROUP BY user_pseudo_id
),

user_monthly_activity AS (
  SELECT DISTINCT
    user_pseudo_id,
    DATE_TRUNC(
      PARSE_DATE('%Y%m%d', event_date),
      MONTH
    ) AS activity_month
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '20201101' AND '20201231'
),

cohort_activity AS (
  SELECT
    first_activity.cohort_month,
    DATE_DIFF(
      monthly_activity.activity_month,
      first_activity.cohort_month,
      MONTH
    ) AS months_since_first_visit,
    COUNT(DISTINCT first_activity.user_pseudo_id) AS retained_users
  FROM user_first_activity AS first_activity
  JOIN user_monthly_activity AS monthly_activity
    ON first_activity.user_pseudo_id = monthly_activity.user_pseudo_id
  GROUP BY 1, 2
),

cohort_size AS (
  SELECT
    cohort_month,
    COUNT(DISTINCT user_pseudo_id) AS cohort_users
  FROM user_first_activity
  GROUP BY 1
)

SELECT
  cohort_activity.cohort_month,
  cohort_activity.months_since_first_visit,
  cohort_size.cohort_users,
  cohort_activity.retained_users,
  ROUND(
    100 * SAFE_DIVIDE(
      cohort_activity.retained_users,
      cohort_size.cohort_users
    ),
    2
  ) AS retention_rate_percent
FROM cohort_activity
JOIN cohort_size
  ON cohort_activity.cohort_month = cohort_size.cohort_month
ORDER BY cohort_month, months_since_first_visit;