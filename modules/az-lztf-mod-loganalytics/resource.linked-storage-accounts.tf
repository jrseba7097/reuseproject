resource "azurerm_log_analytics_linked_storage_account" "logs" {
  count = length(var.linked_storage_accounts) > 0 ? 1 : 0

  data_source_type      = "customlogs"
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  storage_account_ids   = var.linked_storage_accounts
}
