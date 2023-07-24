##################
### Dashboards ###
##################

# Host
resource "newrelic_one_dashboard" "host" {
  name = "NaaS - Hosts Overview"

  page {
    name = "Overview"

    # Page description
    widget_markdown {
      title  = "Page description"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "## Host Monitoring\n\nThis dashboard is meant to provide detailed insights about all of the hosts within the account.\n\nFor each aspect of a host (CPU, MEM...), you can find a dedicated page and per the dashboard variable, you can filter out one or many hosts which you would like to investigate."
    }

    # Host info
    widget_table {
      title  = "Host info"
      column = 4
      row    = 1
      width  = 5
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(operatingSystem) AS `os`, latest(linuxDistribution) AS `distro`, latest(uptime)/60/60/24 AS `upDays`, latest(agentVersion) AS `nrVersion` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Host capacity
    widget_table {
      title  = "Host capacity"
      column = 9
      row    = 1
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(processorCount) AS `cores (count)`, latest(memoryTotalBytes)/1e9 AS `memory (GB)`, latest(diskTotalBytes)/1e9 AS `disk (GB)` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # CPU utilization (%)
    widget_table {
      title  = "CPU utilization (%)"
      column = 1
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuPercent) AS `max`, average(cpuPercent) AS `avg` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # MEM utilization (%)
    widget_table {
      title  = "MEM utilization (%)"
      column = 5
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(memoryUsedPercent) AS `max`, average(memoryUsedPercent) AS `avg` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # STO utilization (%)
    widget_table {
      title  = "STO utilization (%)"
      column = 9
      row    = 4
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(diskUtilizationPercent) AS `max`, average(diskUtilizationPercent) AS `avg` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }
  }

  page {
    name = "CPU"

    # Total CPU utilization (%)
    widget_markdown {
      title  = "Total CPU utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "Total CPU utilization as a percentage. This is not an actual recorded value; it is an alias that combines percentage data from `cpuSystemPercent`, `cpuUserPercent`, `cpuIoWaitPercent` and `cpuStealPercent`.\n\nThis is calculated as:\n\n`(cpuUserPercent + cpuSystemPercent + cpuIOWaitPercent + cpuStealPercent)`"
    }

    # Max total CPU utilization (%)
    widget_bar {
      title  = "Max total CPU utilization (%)"
      column = 4
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Average total CPU utilization (%)
    widget_line {
      title  = "Average total CPU utilization (%)"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(cpuPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Idle CPU utilization (%)
    widget_markdown {
      title  = "Idle CPU utilization (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization capacity that is idle.\n\nThis is calculated as:\n\n`(100.00 - cpuUserPercent - cpuSystemPercent - cpuIOWaitPercent) / elapsed_time`"
    }

    # Max idle CPU utilization (%)
    widget_bar {
      title  = "Max idle CPU utilization (%)"
      column = 4
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuIdlePercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Idle CPU utilization (%)
    widget_line {
      title  = "Idle CPU utilization (%)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(cpuIdlePercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # I/O wait CPU utilization (%)
    widget_markdown {
      title  = "I/O wait CPU utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization composed only of I/O wait time usage.\n\nThis is calculated as:\n\n`current_sample_io_time - previous_sample_io_time) / elapsed_time`"
    }

    # Max I/O wait CPU utilization (%)
    widget_bar {
      title  = "Max I/O wait CPU utilization (%)"
      column = 4
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuIOWaitPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # I/O wait CPU utilization (%)
    widget_line {
      title  = "I/O wait CPU utilization (%)"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(cpuIOWaitPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Steal CPU utilization (%)
    widget_markdown {
      title  = "Steal CPU utilization (%)"
      column = 1
      row    = 10
      width  = 3
      height = 3

      text = "The portion of time when a virtualized CPU is waiting for the hypervisor to make real CPU time available to it."
    }

    # Max steal CPU utilization (%)
    widget_bar {
      title  = "Max steal CPU utilization (%)"
      column = 4
      row    = 10
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuStealPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Steal CPU utilization (%)
    widget_line {
      title  = "Steal CPU utilization (%)"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(cpuStealPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # System CPU utilization (%)
    widget_markdown {
      title  = "System CPU utilization (%)"
      column = 1
      row    = 13
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization composed only of system time usage.\n\nThis is calculated as:\n\n`(current_sample_sys_time - previous_sample_sys_time) / elapsed_time`"
    }

    # Max system CPU utilization (%)
    widget_bar {
      title  = "Max system CPU utilization (%)"
      column = 4
      row    = 13
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuSystemPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # System CPU utilization (%)
    widget_line {
      title  = "System CPU utilization (%)"
      column = 7
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(cpuSystemPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # User CPU utilization (%)
    widget_markdown {
      title  = "User CPU utilization (%)"
      column = 1
      row    = 16
      width  = 3
      height = 3

      text = "The portion of the current CPU utilization composed only of user time usage.\nThis is calculated as:\n\n`current_sample_user_time - previous_sample_user_time) / elapsed_time`"
    }

    # Max user CPU utilization (%)
    widget_bar {
      title  = "Max user CPU utilization (%)"
      column = 4
      row    = 16
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuUserPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # System CPU utilization (%)
    widget_line {
      title  = "System CPU utilization (%)"
      column = 7
      row    = 16
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(cpuUserPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }
  }

  page {
    name = "Memory"

    # MEM utilization (%)
    widget_markdown {
      title  = "MEM utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "The portion of available memory that is in use on this server, in percentage.\n\nThe higher the used space is,\n- the more you are benefiting from the host\n- the less free space you have in case of higher memory allocation (you can consider scaling up)"
    }

    # Max MEM utilization (%)
    widget_bar {
      title  = "Max MEM utilization (%)"
      column = 4
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(memoryUsedPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # MEM utilization (%)
    widget_line {
      title  = "MEM utilization (%)"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(memoryUsedPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # MEM free (%)
    widget_markdown {
      title  = "MEM free (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The portion of free memory available to this server, in percentage.\n\nThe higher the free space is,\n- the more applications you can allocate on the host\n- the less you are benefiting from the host (you can consider shutting it down)"
    }

    # Max MEM free (%)
    widget_bar {
      title  = "Max MEM free (%)"
      column = 4
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(memoryFreePercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # MEM free (%)
    widget_line {
      title  = "MEM free (%)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT average(memoryFreePercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }
  }

  page {
    name = "Storage"

    # STO utilization (%)
    widget_markdown {
      title  = "STO utilization (%)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "The cumulative disk fullness percentage across all supported devices.\n\nThe higher the used space is,\n- the more you are benefiting from your storage\n- the less free space you have for storing critical data (you can consider adding more storage devices)"
    }

    # Max STO utilization (%)
    widget_bar {
      title  = "Max STO utilization (%)"
      column = 4
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT max(diskUsedPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # STO utilization (%)
    widget_line {
      title  = "STO utilization (%)"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT average(diskUsedPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # STO free (%)
    widget_markdown {
      title  = "STO free (%)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The cumulative disk emptiness percentage across all supported devices.\n\nThe higher the free space is,\n- the more space you have to be able to store your data\n- the less you are benefiting from the storage (you can consider removing some storage devices)"
    }

    # Max STO free (%)
    widget_bar {
      title  = "Max STO free (%)"
      column = 4
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT max(diskFreePercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # STO free (%)
    widget_line {
      title  = "STO free (%)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT average(diskFreePercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # STO read utilization (%)
    widget_markdown {
      title  = "STO read utilization (%)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      text = "The portion of disk I/O utilization for read operations..\n\nThe higher the utilization is,\n- the more you are benefiting from the host & disk read capacity\n- the less read throughput you have left for critical high read operations (you can consider increasing read IOPS capacity)"
    }

    # Max STO read utilization (%)
    widget_bar {
      title  = "Max STO read utilization (%)"
      column = 4
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT max(readUtilizationPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # STO read utilization (%)
    widget_line {
      title  = "STO read utilization (%)"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT average(readUtilizationPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # STO write utilization (%)
    widget_markdown {
      title  = "STO write utilization (%)"
      column = 1
      row    = 10
      width  = 3
      height = 3

      text = "The portion of disk I/O utilization for write operations..\n\nThe higher the utilization is,\n- the more you are benefiting from the host & disk write capacity\n- the less write throughput you have left for critical high write operations (you can consider increasing write IOPS capacity)"
    }

    # Max STO write utilization (%)
    widget_bar {
      title  = "Max STO write utilization (%)"
      column = 4
      row    = 10
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT max(writeUtilizationPercent) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # STO write utilization (%)
    widget_line {
      title  = "STO write utilization (%)"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM StorageSample SELECT average(writeUtilizationPercent) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }
  }

  page {
    name = "Network"

    # Receive throughput (MB/sec)
    widget_markdown {
      title  = "Receive throughput (MB/sec)"
      column = 1
      row    = 1
      width  = 3
      height = 3

      text = "The number of megabytes per second received during the sampling period."
    }

    # Max receive throughput (MB/sec)
    widget_bar {
      title  = "Max receive throughput (MB/sec)"
      column = 4
      row    = 1
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT max(receiveBytesPerSecond)/1e6 AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Receive throughput (MB/sec)
    widget_line {
      title  = "Receive throughput (MB/sec)"
      column = 7
      row    = 1
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT average(receiveBytesPerSecond)/1e6 WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Receive drop (packet/sec)
    widget_markdown {
      title  = "Receive drop (packet/sec)"
      column = 1
      row    = 4
      width  = 3
      height = 3

      text = "The number of received packets per second dropped during the sampling period."
    }

    # Max receive drop (packet/sec)
    widget_bar {
      title  = "Max receive drop (packet/sec)"
      column = 4
      row    = 4
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT max(receiveDroppedPerSecond) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Receive drop (packet/sec)
    widget_line {
      title  = "Receive drop (packet/sec)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT average(receiveDroppedPerSecond) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Receive error (1/sec)
    widget_markdown {
      title  = "Receive error (1/sec)"
      column = 1
      row    = 7
      width  = 3
      height = 3

      text = "The number of receive errors per second on the interface during the sampling period."
    }

    # Max receive error (1/sec)
    widget_bar {
      title  = "Max receive error (1/sec)"
      column = 4
      row    = 7
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT max(receiveDroppedPerSecond) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Receive error (1/sec)
    widget_line {
      title  = "Receive error (1/sec)"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT average(receiveDroppedPerSecond) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Transmit throughput (MB/sec)
    widget_markdown {
      title  = "Transmit throughput (MB/sec)"
      column = 1
      row    = 10
      width  = 3
      height = 3

      text = "The number of megabytes per second transmited during the sampling period."
    }

    # Max transmit throughput (MB/sec)
    widget_bar {
      title  = "Max transmit throughput (MB/sec)"
      column = 4
      row    = 10
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT max(transmitBytesPerSecond)/1e6 AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Transmit throughput (MB/sec)
    widget_line {
      title  = "Transmit throughput (MB/sec)"
      column = 7
      row    = 10
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT average(transmitBytesPerSecond)/1e6 WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Transmit drop (packet/sec)
    widget_markdown {
      title  = "Transmit drop (packet/sec)"
      column = 1
      row    = 13
      width  = 3
      height = 3

      text = "The number of transmited packets per second dropped during the sampling period."
    }

    # Max transmit drop (packet/sec)
    widget_bar {
      title  = "Max transmit drop (packet/sec)"
      column = 4
      row    = 13
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT max(transmitDroppedPerSecond) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Transmit drop (packet/sec)
    widget_line {
      title  = "Transmit drop (packet/sec)"
      column = 7
      row    = 13
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT average(transmitDroppedPerSecond) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }

    # Transmit error (1/sec)
    widget_markdown {
      title  = "Transmit error (1/sec)"
      column = 1
      row    = 16
      width  = 3
      height = 3

      text = "The number of transmit errors per second on the interface during the sampling period."
    }

    # Max transmit error (1/sec)
    widget_bar {
      title  = "Max transmit error (1/sec)"
      column = 4
      row    = 16
      width  = 3
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT max(transmitDroppedPerSecond) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Transmit error (1/sec)
    widget_line {
      title  = "Transmit error (1/sec)"
      column = 7
      row    = 16
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM NetworkSample SELECT average(transmitDroppedPerSecond) WHERE hostname IN ({{hostnames}}) FACET hostname TIMESERIES"
      }
    }
  }

  page {
    name = "Process"

    # All running processes
    widget_markdown {
      title  = "All running processes"
      column = 1
      row    = 1
      width  = 4
      height = 3

      text = "Name of all running processes."
    }

    # Host capacity
    widget_table {
      title  = "Host capacity"
      column = 5
      row    = 1
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT latest(processorCount) AS `cores (count)`, latest(memoryTotalBytes)/1e9 AS `memory (GB)`, latest(diskTotalBytes)/1e9 AS `disk (GB)` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Host utilization (%)
    widget_table {
      title  = "Host utilization (%)"
      column = 9
      row    = 1
      width  = 4
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM SystemSample SELECT max(cpuPercent) AS `cpu`, max(memoryUsedPercent) AS `mem`, max(diskUtilizationPercent) AS `sto` WHERE hostname IN ({{hostnames}}) FACET hostname"
      }
    }

    # Average CPU utilization across all cores (%)
    widget_line {
      title  = "Average CPU utilization across all cores (%)"
      column = 1
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM ProcessSample SELECT average(cpuPercent)/latest(numeric(processorCount)) AS `avg` WHERE hostname IN ({{hostnames}}) FACET hostname, processDisplayName TIMESERIES"
      }
    }

    # Max CPU utilization across all cores (%)
    widget_line {
      title  = "Max CPU utilization across all cores (%)"
      column = 7
      row    = 4
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM ProcessSample SELECT max(cpuPercent)/latest(numeric(processorCount)) AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname, processDisplayName TIMESERIES"
      }
    }

    # Average MEM consumption (MB)
    widget_line {
      title  = "Average MEM consumption (MB)"
      column = 1
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM ProcessSample SELECT average(memoryResidentSizeBytes)+average(memoryVirtualSizeBytes)/1000 AS `avg` WHERE hostname IN ({{hostnames}}) FACET hostname, processDisplayName TIMESERIES"
      }
    }

    # Max MEM consumption (MB)
    widget_line {
      title  = "Max MEM consumption (MB)"
      column = 7
      row    = 7
      width  = 6
      height = 3

      nrql_query {
        account_id = var.NEW_RELIC_ACCOUNT_ID
        query      = "FROM ProcessSample SELECT max(memoryResidentSizeBytes)+max(memoryVirtualSizeBytes)/1000 AS `max` WHERE hostname IN ({{hostnames}}) FACET hostname, processDisplayName TIMESERIES"
      }
    }
  }

  variable {
    title                = "Host Names"
    name                 = "hostnames"
    replacement_strategy = "default"
    type                 = "nrql"
    default_values       = ["*"]
    is_multi_selection   = true

    nrql_query {
      account_ids = [var.NEW_RELIC_ACCOUNT_ID]
      query       = "FROM SystemSample SELECT uniques(hostname) LIMIT MAX"
    }
  }
}
