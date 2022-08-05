resource "azurerm_log_analytics_workspace" "main" {
  name                = var.workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.workspace_sku
  retention_in_days   = var.log_retention_days

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
