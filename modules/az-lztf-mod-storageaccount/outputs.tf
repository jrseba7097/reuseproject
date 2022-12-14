output "id" {
  value       = azurerm_storage_account.main.id
  description = "The ID of the Storage Account."
}

output "primary_connection_string" {
  value       = azurerm_storage_account.main.primary_connection_string
  description = "The connection string associated with the primary location."
}

output "primary_access_key" {
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account."
}

output "name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the Storage Account."
}

output "primary_blob_endpoint" {
  value       = azurerm_storage_account.main.primary_blob_endpoint
  description = " The endpoint URL for blob storage in the primary location."
}
