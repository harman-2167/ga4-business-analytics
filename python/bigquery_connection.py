from google.cloud import bigquery

PROJECT_ID = "ga4-business-analytics"


def bigquery_client():
    """
    Create and return a BigQuery client.
    """
    return bigquery.Client(project=PROJECT_ID)


if __name__ == "__main__":
    client = bigquery_client()
    query = """SELECT COUNT(*) AS total_rows
               FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
            """
    result =client.query(query).result()
    for rows in result:
        print(f"Total Rows: {rows.total_rows}")
        