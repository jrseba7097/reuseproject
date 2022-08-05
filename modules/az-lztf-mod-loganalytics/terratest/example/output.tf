output "primary_shared_key" {
  value       = module.testing.primary_shared_key
  description = "The Primary shared key for the Log Analytics Workspace"
  sensitive   = true
}

output "secondary_shared_key" {
  value       = module.testing.secondary_shared_key
  description = "The Secondary shared key for the Log Analytics Workspace"
  sensitive   = true
}

output "workspace_id" {
  value       = module.testing.workspace_id
  description = "The Workspace ID for the Log Analytics Workspace"
}

output "workspace_name" {
  value       = module.testing.workspace_name
  description = "The Workspace Name for the Log Analytics Workspace"
}

output "location" {
  value       = module.testing.location
  description = "The Workspace ID for the Log Analytics Workspace"
}

output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
  description = "The resource group name of the Recovery Services Vault"
}
