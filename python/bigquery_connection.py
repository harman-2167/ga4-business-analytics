from google.cloud import bigquery

PROJECT_ID = "ga4-business-analytics"


def bigquery_client():
    """
    Create and return a BigQuery client.
    """
    return bigquery.Client(project=PROJECT_ID)


if __name__ == "__main__":
    client = bigquery_client()
    print(f"BigQuery connection successful: {client.project}")