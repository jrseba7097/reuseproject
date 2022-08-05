output "vnet_name" {
  value       = azurerm_virtual_network.main.name
  description = "Vnet name"
}

output "vnet_id" {
  value       = azurerm_virtual_network.main.id
  description = "Vnet id"
}

output "address_space" {
  value       = azurerm_virtual_network.main.address_space
  description = "Vnet address space"
}

output "subnet_ids" {
  value       = azurerm_subnet.subnets.*.id
  description = "Subnet Ids in the Vnet"
}
