# Data Limitations and Quality Checks

## Dataset Scope

This project uses the Google Analytics 4 public ecommerce sample dataset. The available analysis period is November–December 2020.

## Key Limitations

- GA4 user identifiers represent browsers/devices and may not represent one individual customer across multiple devices.
- Cookie consent, ad blockers, and tracking implementation issues can cause incomplete event capture.
- GA4 traffic attribution may differ from marketing-platform reporting.
- The short dataset period supports only month-one cohort retention analysis.
- Revenue analysis depends on correctly implemented purchase events.

## Data-Quality Findings

Data-quality checks identified 173 purchase events with either missing/invalid transaction IDs or missing/non-positive purchase revenue.

The transaction ID `(not set)` occurred 583 times. This value is treated as a placeholder rather than a valid order identifier and should be excluded from transaction-level analysis.

Several apparently valid transaction IDs occurred more than once, indicating potential duplicate purchase-event records. Therefore, transaction-level revenue analysis should use distinct valid transaction IDs where appropriate rather than relying only on the count of `purchase` events.