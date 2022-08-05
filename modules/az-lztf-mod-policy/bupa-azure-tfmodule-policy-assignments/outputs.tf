
output "display_name" {
  value       = azurerm_policy_assignment.main.display_name
  description = "The policy assignment display name"
}

output "name" {
  value       = azurerm_policy_assignment.main.name
  description = "The policy assignment name"
}

output "description" {
  value       = azurerm_policy_assignment.main.description
  description = "The policy description"
}

output "scope" {
  value       = azurerm_policy_assignment.main.scope
  description = "The policy assignment scope"
}

output "policy_definition_id" {
  value       = azurerm_policy_assignment.main.policy_definition_id
  description = "The policy assignment id for security_governance"
}
