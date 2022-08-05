output "name" {
  value       = module.testing.name
  description = "UDR table name"
}

output "subnets" {
  value       = module.testing.subnets
  description = "The collection of Subnets associated with this route table"
}

output "id" {
  value       = module.testing.id
  description = "The Route Table ID"
}

output "routes" {
  value       = module.testing.routes
  description = "UD routes"
}
