resource "azurerm_log_analytics_solution" "analytics_solution" {
  count = length(var.solutions)

  solution_name         = var.solutions[count.index].solution_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  workspace_name        = azurerm_log_analytics_workspace.main.name

  plan {
    publisher = var.solutions[count.index].publisher
    product   = var.solutions[count.index].product
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
