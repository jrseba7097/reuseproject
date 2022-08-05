output "subnets" {
  value       = azurerm_route_table.main.subnets
  description = "The collection of Subnets associated with this route table"
}

output "id" {
  value       = azurerm_route_table.main.id
  description = "The Route Table ID"
}

output "name" {
  value       = azurerm_route_table.main.name
  description = "UDR table name"
}

output "routes" {
  value       = azurerm_route.routes
  description = "UD routes"
}
