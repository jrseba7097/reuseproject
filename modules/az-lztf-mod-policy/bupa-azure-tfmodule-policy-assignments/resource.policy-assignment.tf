resource "azurerm_policy_assignment" "main" {
  name                 = var.name
  scope                = var.scope
  policy_definition_id = var.policy_definition_id
  description          = var.description
  display_name         = var.display_name
  location             = var.location

  dynamic "identity" {
    for_each = var.enable_identity ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  metadata = var.metadata

  parameters = var.parameters
}
