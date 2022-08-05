output custom_roles {
  value = azurerm_role_definition.custom_role
  description = "List of definitions created by the module"
}

output "assignments" {
  value       = module.testing.assignments
  description = "List of assignments created by the module"
}
