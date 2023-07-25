##################
### Dashboards ###
##################

# Host
resource "newrelic_one_dashboard" "host" {
  name = "NaaS - ECS Overview"

  page {
    name = "Clusters"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## ECS Monitoring\n\nThis dashboard is meant to provide detailed insights about all of the ECS clusters within the account."
    }

    # Cluster capacity
    widget_table {
      title  = "Cluster capacity"
      column = 4
      row    = 1
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.CpuReserved) AS `cpu`, average(aws.ecs.containerinsights.MemoryReserved) AS `mem`, average(aws.ecs.containerinsights.EphemeralStorageReserved) AS `sto` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName) SELECT sum(`cpu`) AS `CPU (mcores)`, sum(`mem`) AS `MEM (MB)`, sum(`sto`) AS `STO (GB)` FACET aws.accountId, aws.ecs.containerinsights.ClusterName"
      }
    }

    # CPU utilization (%)
    widget_bar {
      title  = "CPU utilization (%)"
      column = 1
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.CpuUtilized) AS `utilized`, average(aws.ecs.containerinsights.CpuReserved) AS `reserved` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName) SELECT sum(`utilized`)/sum(`reserved`)*100 FACET aws.accountId, aws.ecs.containerinsights.ClusterName"
      }
    }

    # MEM utilization (%)
    widget_bar {
      title  = "MEM utilization (%)"
      column = 5
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.MemoryUtilized) AS `utilized`, average(aws.ecs.containerinsights.MemoryReserved) AS `reserved` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName) SELECT sum(`utilized`)/sum(`reserved`)*100 FACET aws.accountId, aws.ecs.containerinsights.ClusterName"
      }
    }

    # STO utilization (%)
    widget_bar {
      title  = "STO utilization (%)"
      column = 9
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.EphemeralStorageUtilized) AS `utilized`, average(aws.ecs.containerinsights.EphemeralStorageReserved) AS `reserved` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName) SELECT sum(`utilized`)/sum(`reserved`)*100 FACET aws.accountId, aws.ecs.containerinsights.ClusterName"
      }
    }

    # CPU utilization (%)
    widget_line {
      title  = "CPU utilization (%)"
      column = 1
      row    = 7
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.CpuUtilized) AS `utilized`, average(aws.ecs.containerinsights.CpuReserved) AS `reserved` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`utilized`)/sum(`reserved`)*100 FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }

    # MEM utilization (%)
    widget_line {
      title  = "MEM utilization (%)"
      column = 5
      row    = 7
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.MemoryUtilized) AS `utilized`, average(aws.ecs.containerinsights.MemoryReserved) AS `reserved` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`utilized`)/sum(`reserved`)*100 FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }

    # STO utilization (%)
    widget_line {
      title  = "STO utilization (%)"
      column = 9
      row    = 7
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.EphemeralStorageUtilized) AS `utilized`, average(aws.ecs.containerinsights.EphemeralStorageReserved) AS `reserved` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`utilized`)/sum(`reserved`)*100 FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }

    # Network receive (MB)
    widget_line {
      title  = "Network receive (MB)"
      column = 1
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.NetworkRxBytes) AS `network` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`network`) FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }

    # Network transmit (MB)
    widget_line {
      title  = "Network transmit (MB)"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.NetworkTxBytes) AS `network` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`network`) FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }

    # Storage read (MB)
    widget_line {
      title  = "Storage read (MB)"
      column = 1
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.StorageReadBytes) AS `storage` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`storage`) FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }

    # Storage write (MB)
    widget_line {
      title  = "Storage write (MB)"
      column = 7
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM (FROM Metric SELECT average(aws.ecs.containerinsights.StorageWriteBytes) AS `storage` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IS NOT NULL FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES) SELECT sum(`storage`) FACET aws.accountId, aws.ecs.containerinsights.ClusterName TIMESERIES"
      }
    }
  }

  page {
    name = "Services"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## ECS Monitoring\n\nThis dashboard is meant to provide detailed insights about all of the ECS services within the account."
    }

    # Service capacity
    widget_table {
      title  = "Service capacity"
      column = 4
      row    = 1
      width  = 9
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.CpuReserved) AS `CPU (mcores)`, average(aws.ecs.containerinsights.MemoryReserved) AS `MEM (MB)`, average(aws.ecs.containerinsights.EphemeralStorageReserved) AS `STO (GB)` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName"
      }
    }

    # CPU utilization (%)
    widget_bar {
      title  = "CPU utilization (%)"
      column = 1
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.CpuUtilized)/average(aws.ecs.containerinsights.CpuReserved)*100 AS `Utilization` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName"
      }
    }

    # MEM utilization (%)
    widget_bar {
      title  = "MEM utilization (%)"
      column = 5
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.MemoryUtilized)/average(aws.ecs.containerinsights.MemoryReserved)*100 AS `Utilization` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName"
      }
    }

    # STO utilization (%)
    widget_bar {
      title  = "STO utilization (%)"
      column = 9
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.EphemeralStorageUtilized)/average(aws.ecs.containerinsights.EphemeralStorageReserved)*100 AS `Utilization` WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName"
      }
    }

    # CPU utilization (%)
    widget_line {
      title  = "CPU utilization (%)"
      column = 1
      row    = 7
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.CpuUtilized)/average(aws.ecs.containerinsights.CpuReserved)*100 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }

    # MEM utilization (%)
    widget_line {
      title  = "MEM utilization (%)"
      column = 5
      row    = 7
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.MemoryUtilized)/average(aws.ecs.containerinsights.MemoryReserved)*100 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }

    # STO utilization (%)
    widget_line {
      title  = "STO utilization (%)"
      column = 9
      row    = 7
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.EphemeralStorageUtilized)/average(aws.ecs.containerinsights.EphemeralStorageReserved)*100 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }

    # Network receive (MB)
    widget_line {
      title  = "Network receive (MB)"
      column = 1
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.NetworkRxBytes)/1000 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }

    # Network transmit (MB)
    widget_line {
      title  = "Network transmit (MB)"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.NetworkTxBytes)/1000 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }

    # Storage read (MB)
    widget_line {
      title  = "Storage read (MB)"
      column = 1
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.StorageReadBytes)/1000 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }

    # Storage write (MB)
    widget_line {
      title  = "Storage write (MB)"
      column = 7
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM Metric SELECT average(aws.ecs.containerinsights.StorageWriteBytes)/1000 WHERE aws.accountId IN ({{awsaccounts}}) AND aws.ecs.containerinsights.ClusterName IN ({{clusternames}}) AND aws.ecs.ServiceName IN ({{servicenames}}) FACET aws.accountId, aws.ecs.containerinsights.ClusterName, aws.ecs.ServiceName TIMESERIES"
      }
    }
  }

  variable {
    title                = "AWS Accounts"
    name                 = "awsaccounts"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM Metric SELECT uniques(aws.accountId) WHERE aws.ecs.ServiceName IS NOT NULL LIMIT MAX"
    }
  }

  variable {
    title                = "Cluster Names"
    name                 = "clusternames"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM Metric SELECT uniques(aws.ecs.containerinsights.ClusterName) WHERE aws.ecs.ServiceName IS NOT NULL LIMIT MAX"
    }
  }

  variable {
    title                = "Service Names"
    name                 = "servicenames"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM Metric SELECT uniques(aws.ecs.ServiceName) LIMIT MAX"
    }
  }
}
