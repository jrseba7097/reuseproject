resource "azurerm_monitor_diagnostic_setting" "logs" {
  count = lower(var.enable_logs) == "true" ? 1 : 0

  name                       = var.diag_name
  target_resource_id         = azurerm_key_vault.main.id
  storage_account_id         = var.storage_account_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AuditEvent"
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
}
