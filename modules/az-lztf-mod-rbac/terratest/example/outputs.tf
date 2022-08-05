output "custom_roles" {
  value       = module.testing.custom_roles
  description = "List of definitions created by the module"
}

output "assignments" {
  value       = module.testing.assignments
  description = "List of assignments created by the module"
}
