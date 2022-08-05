
output "id" {
  value       = module.testing.id
  description = "The ID of the Storage Account."
}

output "primary_connection_string" {
  value       = module.testing.primary_connection_string
  description = "The connection string associated with the primary location."
  sensitive   = true
}

output "primary_access_key" {
  value       = module.testing.primary_access_key
  description = "The primary access key for the storage account."
  sensitive   = true
}

output "name" {
  value       = module.testing.name
  description = "The name of the Storage Account."
}

output "resource_group_name" {
  value       = azurerm_resource_group.test.name
  description = "The name of the Storage Account."
}

output "location" {
  value       = azurerm_resource_group.test.location
  description = "The name of the Storage Account."
}