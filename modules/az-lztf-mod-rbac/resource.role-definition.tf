resource "azurerm_role_definition" "custom_role" {
  count = length(var.custom_role_definitions)

  name        = var.custom_role_definitions[count.index].name
  scope       = var.custom_role_definitions[count.index].scope
  description = var.custom_role_definitions[count.index].description

  permissions {
    actions          = lookup(var.custom_role_definitions[count.index].permissions, "actions", [])
    not_actions      = lookup(var.custom_role_definitions[count.index].permissions, "not_actions", [])
    data_actions     = lookup(var.custom_role_definitions[count.index].permissions, "data_actions", [])
    not_data_actions = lookup(var.custom_role_definitions[count.index].permissions, "not_data_actions", [])
  }

  assignable_scopes = var.custom_role_definitions[count.index].assignable_scopes
}
