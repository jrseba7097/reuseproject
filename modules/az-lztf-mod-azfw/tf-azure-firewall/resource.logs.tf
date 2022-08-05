resource "azurerm_monitor_diagnostic_setting" "logs" {
  count = lower(var.enable) == "true" ? (lower(var.enable_logs) == "true" ? 1 : 0) : 0

  name                       = "firewall_logs"
  target_resource_id         = azurerm_firewall.main[0].id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true

    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true

    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true

    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = var.retention_days
      enabled = true
    }
  }
  timeouts {}
}
