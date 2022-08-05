resource "azurerm_management_group" "mg" {
  display_name               = var.management_groups.display_name
  name                       = var.management_groups.name
  parent_management_group_id = can(var.parent_management_group_id) ? var.parent_management_group_id : null
  subscription_ids           = var.management_groups.subscription_ids
}
