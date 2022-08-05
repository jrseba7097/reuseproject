output "id" {
  value       = azurerm_network_security_group.main.id
  description = "The ID of the Network Security Group"
}

output "name" {
  value       = azurerm_network_security_group.main.name
  description = "The name of the Network Security Group"
}

output "rules" {
  value       = azurerm_network_security_rule.rules
  description = "The rules of the Network Security Group"
}
