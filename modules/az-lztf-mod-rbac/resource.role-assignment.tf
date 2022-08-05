resource "azurerm_role_assignment" "assignment" {
  count = length(var.role_assignments)

  scope                = var.role_assignments[count.index].assignment_scope
  role_definition_name = try(var.role_assignments[count.index].role_definition_name, null)
  role_definition_id   = try(var.role_assignments[count.index].role_definition_id, null)
  principal_id         = var.role_assignments[count.index].principal_id
}
