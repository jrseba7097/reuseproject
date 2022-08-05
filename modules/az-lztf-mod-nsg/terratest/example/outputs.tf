output "id" {
  value       = module.testing.id
  description = "The ID of the Network Security Group"
}

output "name" {
  value       = module.testing.name
  description = "The name of the Network Security Group"
}

output "rules" {
  value       = module.testing.rules
  description = "The rules of the Network Security Group"
}
