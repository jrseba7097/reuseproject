output "id" {
  value       = azurerm_bastion_host.bastion.id
  description = "The ID of the Bastion Host."
}

output "name" {
  value       = azurerm_bastion_host.bastion.name
  description = "The name of the Bastion Host."
}

output "public_ip_id" {
  value       = azurerm_public_ip.bastion_ip.id
  description = "Public IP Address ID associated with this Bastion Host."
}
