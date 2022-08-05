resource "azurerm_management_group" "mg" {
  display_name               = var.management_groups.display_name
  name                       = var.management_groups.name
  parent_management_group_id = can(var.parent_management_group_id) ? var.parent_management_group_id : null
  subscription_ids           = var.management_groups.subscription_ids
}

module "children" {
  source   = "../level2"
  count = length(var.management_groups.children)

  parent_management_group_id  = azurerm_management_group.mg.id
  management_groups           = var.management_groups.children[count.index]
}
