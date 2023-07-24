#################
### Dashboard ###
#################

# APM
resource "newrelic_one_dashboard" "relations" {
  count = length(var.app_relation_map)
  name  = "NaaS - APM Overview - ${var.app_relation_map[count.index].app_name}"

  page {
    name = "Docs"

    # Docs
    widget_markdown {
      title  = var.NEW_RELIC_ACCOUNT_ID
      row    = 1
      column = 1
      height = 5
      width  = 12

      text = "# Troubleshooting\n\nThis dashboard is dedicated to retrieve all necessary spans and logs that belong to a particular trace from all applications in all New Relic accounts with which this application is communicating to.\n\nWhenever you are given a trace ID which corresponds to a transaction with a problem, you can paste that trace ID to the dashboard variable and the widgets will automatically adapt themselves to show you only the spans and logs of that trace.\n\n\nIf you are interested in having more information explicitly to this application, you can refer to the [Overview dashboard](${newrelic_one_dashboard.apm.permalink}) where you can filter the widgets by putting the name of this applications into the dashboard variables.\n\nThe related application names grouped according to their New Relic account IDs are as follows:\n```json\n${jsonencode(var.app_relation_map)}\n```\n"
    }
  }

  #############
  ### SPANS ###
  #############
  page {
    name = "Spans"

    widget_table {
      title  = var.NEW_RELIC_ACCOUNT_ID
      row    = 1
      column = 1
      height = 5
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Span SELECT * WHERE entity.name = '${var.app_relation_map[count.index].app_name}' AND trace.id = {{traceId}} LIMIT MAX"
      }
    }

    dynamic "widget_table" {
      for_each = var.app_relation_map[count.index].related_apps

      content {
        title  = widget_table.value.account_id
        row    = 6 + 5 * index(var.app_relation_map[count.index].related_apps, widget_table.value)
        column = 1
        height = 5
        width  = 12

        nrql_query {
          account_id = widget_table.value.account_id
          query      = "FROM Span SELECT * WHERE entity.name IN ('${replace(widget_table.value.app_names, ",", "','")}') AND trace.id = {{traceId}} LIMIT MAX"
        }
      }
    }
  }

  ############
  ### LOGS ###
  ############
  page {
    name = "Logs"

    widget_table {
      title  = var.NEW_RELIC_ACCOUNT_ID
      row    = 1
      column = 1
      height = 5
      width  = 12

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Log SELECT * WHERE entity.name = '${var.app_relation_map[count.index].app_name}' AND trace.id = {{traceId}} LIMIT MAX"
      }
    }

    dynamic "widget_table" {
      for_each = var.app_relation_map[count.index].related_apps

      content {
        title  = widget_table.value.account_id
        row    = 6 + 5 * index(var.app_relation_map[count.index].related_apps, widget_table.value)
        column = 1
        height = 5
        width  = 12

        nrql_query {
          account_id = widget_table.value.account_id
          query      = "FROM Log SELECT * WHERE entity.name IN ('${replace(widget_table.value.app_names, ",", "','")}') AND trace.id = {{traceId}} LIMIT MAX"
        }
      }
    }
  }

  variable {
    title                = "Trace ID"
    name                 = "traceId"
    replacement_strategy = "string"
    type                 = "string"
  }
}
