#################
### Dashboard ###
#################

# APM
resource "newrelic_one_dashboard" "apm" {
  name = "NaaS - APM Overview"

  ####################
  ### WEB INSIGHTS ###
  ####################
  page {
    name = "Web Insights"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 2
      width  = 3

      text = "## Overview Insights\n\n### Web transactions\nRefers to synchronous calls\n- HTTP\n- gRPC"
    }

    # Average web response time (ms)
    widget_billboard {
      title  = "Average web response time (ms)"
      row    = 1
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.transaction.duration*1000)  AS `Average web response time (ms)` WHERE appName IN ({{apmnames}}) AND transactionType = 'Web'"
      }
    }

    # Average web throughput (rpm)
    widget_billboard {
      title  = "Average web throughput (rpm)"
      row    = 1
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average web throughput (rpm)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' LIMIT MAX"
      }
    }

    # Average web error rate (%)
    widget_billboard {
      title  = "Average web error rate (%)"
      row    = 1
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' LIMIT MAX"
      }
    }

    # Web response time by segment (ms)
    widget_area {
      title  = "Web response time by segment (ms)"
      row    = 3
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.overview.web*1000) WHERE appName IN ({{apmnames}}) FACET segmentName TIMESERIES LIMIT MAX"
      }
    }

    # Web response time by instance (ms)
    widget_line {
      title  = "Web response time by instance (ms)"
      row    = 3
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.transaction.duration*1000) AS `duration` WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' FACET instanceName TIMESERIES"
      }
    }

    # Average web throughput (rpm)
    widget_line {
      title  = "Average web throughput (rpm)"
      row    = 6
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) AS 'Average web throughput (rpm)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' TIMESERIES"
      }
    }

    # Average web throughput by instance (rpm)
    widget_line {
      title  = "Average web throughput by instance (rpm)"
      row    = 6
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' FACET instanceName TIMESERIES"
      }
    }

    # Average web error rate (%)
    widget_line {
      title  = "Average web error rate (%)"
      row    = 9
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' TIMESERIES"
      }
    }

    # Average web error rate by instance (%)
    widget_line {
      title  = "Average web error rate by instance (%)"
      row    = 9
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average web error rate (%)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Web' FACET instanceName TIMESERIES"
      }
    }
  }

  ########################
  ### NON-WEB INSIGHTS ###
  ########################
  page {
    name = "Non-Web Insights"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 2
      width  = 3

      text = "## Overview Insights\n\n### Non-web transactions\nRefers to asynchronous calls.\n- Kafka\n- SQS\n- Service Bus"
    }

    # Average non-web response time (ms)
    widget_billboard {
      title  = "Average non-web response time (ms)"
      row    = 1
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.transaction.duration*1000) AS `Average non-web response time (ms)` WHERE appName IN ({{apmnames}}) AND transactionType = 'Other'"
      }
    }

    # Average non-web throughput (rpm)
    widget_billboard {
      title  = "Average non-web throughput (rpm)"
      row    = 1
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) as 'Average non-web throughput (rpm)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' LIMIT MAX"
      }
    }

    # Average non-web error rate (%)
    widget_billboard {
      title  = "Average non-web error rate (%)"
      row    = 1
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 as 'Average non-web error rate (%)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' LIMIT MAX"
      }
    }

    # Non-web response time by segment (ms)
    widget_area {
      title  = "Non-web response time by segment (ms)"
      row    = 3
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.overview.other*1000) WHERE appName IN ({{apmnames}}) FACET segmentName TIMESERIES"
      }
    }

    # Non-web response time by instance (ms)
    widget_area {
      title  = "Non-web response time by instance (ms)"
      row    = 3
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.transaction.druation*1000) WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' FACET instanceName TIMESERIES"
      }
    }

    # Average non-web throughput (rpm)
    widget_line {
      title  = "Average non-web throughput (rpm)"
      row    = 7
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) AS 'Average non-web throughput (rpm)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' TIMESERIES"
      }
    }

    # Average non-web throughput by instance (rpm)
    widget_line {
      title  = "Average non-web throughput by instance (rpm)"
      row    = 7
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.transaction.duration), 1 minute) WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' FACET instanceName TIMESERIES"
      }
    }

    # Average non-web error rate (%)
    widget_line {
      title  = "Average non-web error rate (%)"
      row    = 10
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 AS 'Average non-web error rate (%)' WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' TIMESERIES"
      }
    }

    # Average non-web error rate by instance (%)
    widget_line {
      title  = "Average non-web error rate by instance (%)"
      row    = 10
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT count(apm.service.error.count)/count(apm.service.transaction.duration)*100 WHERE appName IN ({{apmnames}}) AND transactionType = 'Other' FACET instanceName TIMESERIES"
      }
    }
  }

  ############################
  ### RESOURCE CONSUMPTION ###
  ############################
  page {
    name = "Resource consumption"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 2
      width  = 4

      text = "## Resource Consumption\nThis page is dedicated to give an overview of the resource (CPU/MEM) consumption of the application.\n\nFor better understanding, it is highly recommended to retrieve the consumption data per infrastructure agent or Prometheus etc."
    }

    # CPU utilization (%)
    widget_billboard {
      title  = "CPU utilization (%)"
      row    = 1
      column = 5
      height = 2
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.cpu.usertime.utilization) AS `avg`, max(apm.service.cpu.usertime.utilization) AS `max` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # MEM utilization (MB)
    widget_billboard {
      title  = "MEM utilization (MB)"
      row    = 1
      column = 9
      height = 2
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.memory.physical) AS `avg`, max(apm.service.memory.physical) AS `max` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Average CPU utilization (%)
    widget_line {
      title  = "Average CPU utilization (%)"
      row    = 3
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.cpu.usertime.utilization) AS `cpu` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Average CPU utilization by instance (%)
    widget_line {
      title  = "Average CPU utilization by instance (%)"
      row    = 3
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.cpu.usertime.utilization) AS `cpu` WHERE appName IN ({{apmnames}}) FACET instanceName TIMESERIES LIMIT 10"
      }
    }

    # Maximum CPU utilization (%)
    widget_line {
      title  = "Maximum CPU utilization (%)"
      row    = 6
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.cpu.usertime.utilization) AS `cpu` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Maximum CPU utilization by instance (%)
    widget_line {
      title  = "Maximum CPU utilization by instance (%)"
      row    = 6
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.cpu.usertime.utilization) AS `cpu` WHERE appName IN ({{apmnames}}) FACET instanceName TIMESERIES LIMIT 10"
      }
    }

    # Average MEM usage (MB)
    widget_line {
      title  = "Average MEM usage (MB)"
      row    = 9
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.memory.physical) AS `mem` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Average MEM usage by instance (MB)
    widget_line {
      title  = "Average MEM usage by instance (MB)"
      row    = 9
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.memory.physical) AS `mem` WHERE appName IN ({{apmnames}}) FACET instanceName TIMESERIES LIMIT 10"
      }
    }

    # Maximum MEM usage (MB)
    widget_line {
      title  = "Maximum CPU usage (MB)"
      row    = 12
      column = 1
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.memory.physical) AS `mem` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Maximum MEM usage by instance (MB)
    widget_line {
      title  = "Maximum MEM usage by instance (MB)"
      row    = 12
      column = 7
      height = 3
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT max(apm.service.memory.physical) AS `mem` WHERE appName IN ({{apmnames}}) FACET instanceName TIMESERIES LIMIT 10"
      }
    }
  }

  ####################
  ### TRANSACTIONS ###
  ####################
  page {
    name = "Transactions"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 3
      width  = 3

      text = "## Transactions\n\nThis page is dedicated for the transactions which are tracked and sent to New Relic. In cases of high throughput, the agent starts dropping and not tracking all transactions.\n\nTherefore, this view is not exactly appropriate to make a judgement about the overall application performance but to investigate a portion of detailed traces."
    }

    # Overview
    widget_billboard {
      title  = "Overview"
      row    = 1
      column = 4
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) AS `Total transactions`, average(duration)*1000 AS `Average duration (ms)`, percentile(duration*1000, 90) as `Slowest duration (ms)` WHERE appName IN ({{apmnames}}) LIMIT MAX"
      }
    }

    # Transaction count by instance
    widget_line {
      title  = "Transaction count by instance"
      row    = 1
      column = 8
      height = 3
      width  = 5

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT rate(count(*), 1 minute) WHERE appName IN ({{apmnames}}) FACET host LIMIT MAX TIMESERIES"
      }
    }

    # Transaction count by type
    widget_pie {
      title  = "Transaction count by type"
      row    = 4
      column = 1
      height = 4
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE appName IN ({{apmnames}}) FACET transactionType LIMIT 10"
      }
    }

    # Transaction count by method
    widget_pie {
      title  = "Transaction count by method"
      row    = 4
      column = 4
      height = 4
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE appName IN ({{apmnames}}) FACET request.method LIMIT 10"
      }
    }

    # Transaction count by name
    widget_bar {
      title  = "Transaction count by name"
      row    = 4
      column = 7
      height = 4
      width  = 6

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE appName IN ({{apmnames}}) FACET name LIMIT 20"
      }
    }

    # Transactions with errors
    widget_table {
      title  = "Transactions with errors"
      row    = 10
      column = 1
      height = 5
      width  = 8

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM TransactionError SELECT host, error.expected, error.class, error.message, traceId WHERE appName IN ({{apmnames}}) LIMIT MAX"
      }
    }

    # Transaction count by URI
    widget_bar {
      title  = "Transaction count by URI"
      row    = 10
      column = 9
      height = 5
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Transaction SELECT count(*) WHERE appName IN ({{apmnames}}) FACET request.uri LIMIT 20"
      }
    }
  }

  #############################
  ### EXTERNAL INTERACTIONS ###
  #############################
  page {
    name = "External Interactions"

    # Page description
    widget_markdown {
      title  = "Page description"
      row    = 1
      column = 1
      height = 4
      width  = 3

      text = "## External Interactions\n\nThis page is dedicated for the external transactions. This would include:\n- the external calls to other services (e.g. HTTP/gRPC requests)\n- the database calls (e.g. MySQL, Postgres).\n\n### Bare in mind!\n\n the widgets which are using `Transaction` or `Span` do not correspond to the overall behaviour of the application, since the agent starts dropping and not tracking all transactions in cases of high throughput."
    }

    # Total database operation duration (ms)
    widget_billboard {
      title  = "Total database operation duration (ms)"
      row    = 1
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT sum(apm.service.datastore.operation.duration * 1000) AS `Total database operation duration (ms)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Average database operation duration (ms)
    widget_billboard {
      title  = "Average database operation duration (ms)"
      row    = 1
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.datastore.operation.duration * 1000) AS `Average database operation duration (ms)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Throughput of database operations (rpm)
    widget_billboard {
      title  = "Throughput of database operations (rpm)"
      row    = 1
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.datastore.operation.duration), 1 minute) AS `Database operation throughput (rpm)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Total external call duration (ms)
    widget_billboard {
      title  = "Total external call duration (ms)"
      row    = 3
      column = 4
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT sum(apm.service.external.total.duration * 1000) AS `Total external call duration (ms)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Average external call duration (ms)
    widget_billboard {
      title  = "Average external call duration (ms)"
      row    = 3
      column = 7
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.external.total.duration * 1000) AS `Average external call duration (ms)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Throughput of external calls (rpm)
    widget_billboard {
      title  = "Throughput of external calls (rpm)"
      row    = 3
      column = 10
      height = 2
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.external.total.duration), 1 minute) AS `external call throughput (rpm)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Database table analysis
    widget_markdown {
      title  = "Database table analysis"
      row    = 5
      column = 1
      height = 3
      width  = 3

      text = "## Database table analysis\n\nThe database calls of the application can be tracked by:\n- Database server\n- Database table\n- Operation type\n\nFurther investigation can be performed by inspecting the individual spans."
    }

    # Total operation durations by database/table/type (ms)
    widget_bar {
      title  = "Total operation durations by database/table/type (ms)"
      row    = 5
      column = 4
      height = 3
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT sum(apm.service.datastore.operation.duration * 1000) WHERE appName IN ({{apmnames}}) FACET `datastoreType`, `table`, `operation`"
      }
    }

    # Average operation durations by database/table/type (ms)
    widget_bar {
      title  = "Average operation durations by database/table/type (ms)"
      row    = 5
      column = 7
      height = 3
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.datastore.operation.duration * 1000) WHERE appName IN ({{apmnames}}) FACET `datastoreType`, `table`, `operation`"
      }
    }

    # Throughput of operations by database/table/type (rpm)
    widget_bar {
      title  = "Throughput of operations by database/table/type (rpm)"
      row    = 5
      column = 10
      height = 3
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.datastore.operation.duration), 1 minute) WHERE appName IN ({{apmnames}}) FACET concat(datastoreType, ' ', table, ' ', operation)"
      }
    }

    # Total operation durations by database/table/type (ms)
    widget_area {
      title  = "Total operation durations by database/table/type (ms)"
      row    = 8
      column = 1
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT sum(apm.service.datastore.operation.duration * 1000) WHERE appName IN ({{apmnames}}) FACET `datastoreType`, `table`, `operation` TIMESERIES"
      }
    }

    # Average operation durations by database/table/type (ms)
    widget_area {
      title  = "Average operation durations by database/table/type (ms)"
      row    = 8
      column = 5
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.datastore.operation.duration * 1000) WHERE appName IN ({{apmnames}}) FACET `datastoreType`, `table`, `operation` TIMESERIES"
      }
    }

    # Throughput of operations by database/table/type (rpm)
    widget_area {
      title  = "Throughput of operations by database/table/type (rpm)"
      row    = 8
      column = 9
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.datastore.operation.duration), 1 minute) WHERE appName IN ({{apmnames}}) FACET concat(datastoreType, ' ', table, ' ', operation) TIMESERIES"
      }
    }

    # Long database call spans
    widget_table {
      title  = "Long database call spans"
      row    = 11
      column = 1
      height = 4
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT component, db.instance, db.collection, db.statement, duration.ms, host, trace.id WHERE appName IN ({{apmnames}}) AND db.statement IS NOT NULL AND duration.ms > (FROM Span SELECT percentile(duration.ms, 90) WHERE appName IN ({{apmnames}}) AND db.statement IS NOT NULL)"
      }
    }

    # External call analysis
    widget_markdown {
      title  = "External call analysis"
      row    = 15
      column = 1
      height = 3
      width  = 3

      text = "## External call analysis\n\nThe external calls of the application can be taken into consideration as follows:\n- Total duration\n- External host\n\nFurther investigation can be performed by inspecting the individual spans."
    }

    # Total external call duration by host (ms)
    widget_bar {
      title  = "Total external call duration by host (ms)"
      row    = 15
      column = 4
      height = 3
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT sum(apm.service.external.host.duration * 1000) AS `Total external call duration (ms)` WHERE appName IN ({{apmnames}}) FACET external.host TIMESERIES"
      }
    }

    # Average external call duration by host (ms)
    widget_bar {
      title  = "Average external call duration by host (ms)"
      row    = 15
      column = 7
      height = 3
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.external.host.duration * 1000) AS `Average external call duration (ms)` WHERE appName IN ({{apmnames}}) FACET external.host TIMESERIES"
      }
    }

    # Throughput of external calls by host (rpm)
    widget_bar {
      title  = "Throughput of external calls (rpm)"
      row    = 15
      column = 10
      height = 3
      width  = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.external.host.duration), 1 minute) AS `external call throughput (rpm)` WHERE appName IN ({{apmnames}}) FACET external.host TIMESERIES"
      }
    }

    # Total external call duration (ms)
    widget_line {
      title  = "Total external call duration (ms)"
      row    = 18
      column = 1
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT sum(apm.service.external.total.duration * 1000) AS `Total external call duration (ms)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Average external call duration (ms)
    widget_line {
      title  = "Average external call duration (ms)"
      row    = 18
      column = 5
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(apm.service.external.total.duration * 1000) AS `Average external call duration (ms)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Throughput of external calls (rpm)
    widget_line {
      title  = "Throughput of external calls (rpm)"
      row    = 18
      column = 9
      height = 3
      width  = 4

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT rate(count(apm.service.external.total.duration), 1 minute) AS `external call throughput (rpm)` WHERE appName IN ({{apmnames}}) TIMESERIES"
      }
    }

    # Long external call spans
    widget_table {
      title  = "Long external call spans"
      row    = 22
      column = 1
      height = 4
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT http.statusCode, http.url, host, trace.id, duration.ms WHERE appName IN ({{apmnames}}) AND span.kind = 'client' AND duration.ms > (FROM Span SELECT percentile(duration.ms, 90) WHERE appName IN ({{apmnames}}) AND span.kind = 'client')"
      }
    }

    # Failed external call spans
    widget_table {
      title  = "Failed external call spans"
      row    = 26
      column = 1
      height = 4
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT http.statusCode, http.url, host, trace.id, duration.ms WHERE appName IN ({{apmnames}}) AND span.kind = 'client' AND http.statusCode > 399"
      }
    }
  }

  variable {
    title                = "APM Names"
    name                 = "apmnames"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM Transaction SELECT uniques(appName) LIMIT MAX"
    }
  }
}
