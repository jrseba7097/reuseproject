
output "display_name" {
  value       = module.testing.display_name
  description = "The policy assignment display name"
}

output "name" {
  value       = module.testing.name
  description = "The policy assignment name"
}

output "description" {
  value       = module.testing.description
  description = "The policy description"
}

output "scope" {
  value       = module.testing.scope
  description = "The policy assignment scope"
}

output "policy_definition_id" {
  value       = module.testing.policy_definition_id
  description = "The policy assignment id for security_governance"
}
