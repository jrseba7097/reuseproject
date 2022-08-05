output "public_ip_address" {
  value       = var.enable == "true" ? azurerm_public_ip.azure_firewall_pip[0].ip_address : ""
  description = "The public IP address value that was allocated for the Firewall"
}

output "private_ip_address" {
  value       = var.enable == "true" ? azurerm_firewall.main[0].ip_configuration[0].private_ip_address : ""
  description = "The private IP address value that was allocated for the Firewall"
}

output "id" {
  value       = var.enable == "true" ? azurerm_firewall.main[0].id : ""
  description = "Firewall resource id"
}
