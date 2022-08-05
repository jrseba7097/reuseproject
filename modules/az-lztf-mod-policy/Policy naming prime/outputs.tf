output "policy_set_assignment_id" {
  value       = azurerm_policy_assignment.initiative.id
  description = "The policy set assignment id"
}

output "policy_set_definition_id" {
  value       = azurerm_policy_set_definition.initiative.id
  description = "The policy set definition id"
}

output "policy_set_assignment_name" {
  value       = azurerm_policy_assignment.initiative.name
  description = "The policy set assignment name"
}

output "policy_set_definition_name" {
  value       = azurerm_policy_set_definition.initiative.name
  description = "The policy set definition name"
}
