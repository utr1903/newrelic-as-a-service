##################
### Dashboards ###
##################

# Data ingest
resource "newrelic_one_dashboard" "ingest" {
  name = "NaaS - Data Ingest Breakdown"

  page {
    name = "Overview"

    # Total ingest since a year (GB)
    widget_billboard {
      title  = "Total ingest since a year (GB)"
      column = 1
      row    = 1
      width  = 3
      height = 2

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'GB' SINCE 12 months AGO"
      }
    }

    # Total ingest per month since a year (GB)
    widget_area {
      title  = "Total ingest per month since a year (GB)"
      column = 4
      row    = 1
      width  = 9
      height = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' SINCE 12 months AGO LIMIT MAX TIMESERIES"
      }
    }

    # Total ingest per month since a year (GB)
    widget_table {
      title  = "Total ingest per month since a year (GB)"
      column = 1
      row    = 3
      width  = 3
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' FACET monthOf(timestamp) SINCE 12 months AGO LIMIT MAX"
      }
    }

    # Total ingest per type since a year (GB)
    widget_pie {
      title  = "Total ingest per type since a year (GB)"
      column = 1
      row    = 7
      width  = 3
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' FACET usageMetric SINCE 12 months AGO LIMIT MAX"
      }
    }

    # Total ingest per type since a year (GB)
    widget_area {
      title  = "Total ingest per type since a year (GB)"
      column = 4
      row    = 7
      width  = 9
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' FACET usageMetric SINCE 12 months AGO LIMIT MAX TIMESERIES"
      }
    }
  }

  page {
    name = "APM & Services"

    # Total ingest per type since a year (GB)
    widget_billboard {
      title  = "Total ingest per type since a year (GB)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' WHERE usageMetric IN ('TracingBytes', 'ApmEventsBytes', 'SecurityBytes') FACET usageMetric SINCE 12 months AGO LIMIT MAX"
      }
    }

    # Total ingest per type since a year (GB)
    widget_area {
      title  = "Total ingest per type since a year (GB)"
      column = 4
      row    = 1
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' WHERE usageMetric IN ('TracingBytes', 'ApmEventsBytes', 'SecurityBytes') FACET usageMetric SINCE 12 months AGO LIMIT MAX TIMESERIES"
      }
    }

    # Transactions per top 20 app (GB)
    widget_pie {
      title  = "Transactions per top 20 app (GB)"
      column = 1
      row    = 4
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError, TransactionTrace, ErrorTrace SELECT bytecountestimate()/1e9 FACET appName LIMIT 20"
      }
    }

    # Transactions per top 20 app (GB)
    widget_area {
      title  = "Transactions per top 20 app (GB)"
      column = 5
      row    = 4
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction, TransactionError, TransactionTrace, ErrorTrace SELECT bytecountestimate()/1e9 FACET appName LIMIT 20 TIMESERIES"
      }
    }

    # Spans per top 20 app (GB)
    widget_pie {
      title  = "Spans per top 20 app (GB)"
      column = 1
      row    = 8
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT bytecountestimate()/1e9 WHERE instrumentation.provider != 'pixie' FACET appName OR service.name LIMIT 20"
      }
    }

    # Spans per top 20 app (GB)
    widget_area {
      title  = "Spans per top 20 app (GB)"
      column = 5
      row    = 8
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT bytecountestimate()/1e9 WHERE instrumentation.provider != 'pixie' FACET appName OR service.name LIMIT 20 TIMESERIES"
      }
    }

    # Metrics per top 20 app (GB)
    widget_pie {
      title  = "Metrics per top 20 app (GB)"
      column = 1
      row    = 12
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT bytecountestimate()/1e9 WHERE instrumentation.provider != 'pixie' FACET appName OR service.name LIMIT 20"
      }
    }

    # Metrics per top 20 app (GB)
    widget_area {
      title  = "Metrics per top 20 app (GB)"
      column = 5
      row    = 12
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT bytecountestimate()/1e9 WHERE instrumentation.provider != 'pixie' FACET appName OR service.name LIMIT 20 TIMESERIES"
      }
    }
  }

  page {
    name = "Logs"

    # Total ingest per type since a year (GB)
    widget_billboard {
      title  = "Total ingest per type since a year (GB)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' WHERE usageMetric = 'LoggingBytes' SINCE 12 months AGO LIMIT MAX"
      }
    }

    # Total ingest per type since a year (GB)
    widget_area {
      title  = "Total ingest per type since a year (GB)"
      column = 4
      row    = 1
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NrConsumption SELECT sum(GigabytesIngested) AS 'Gigabytes Ingested' WHERE usageMetric = 'LoggingBytes' SINCE 12 months AGO LIMIT MAX TIMESERIES"
      }
    }

    # Logs per top 20 app (GB)
    widget_pie {
      title  = "Logs per top 20 app (GB)"
      column = 1
      row    = 4
      width  = 4
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Log, LogExtendedRecord SELECT bytecountestimate()/10e8 WHERE instrumentation.provider != 'kentik' FACET labels.app SINCE 12 months AGO LIMIT 20"
      }
    }

    # Logs per top 20 app (GB)
    widget_area {
      title  = "Logs per top 20 app (GB)"
      column = 5
      row    = 4
      width  = 8
      height = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Log, LogExtendedRecord SELECT bytecountestimate()/10e8 WHERE instrumentation.provider != 'kentik' FACET labels.app SINCE 12 months AGO LIMIT 20 TIMESERIES"
      }
    }
  }
}
