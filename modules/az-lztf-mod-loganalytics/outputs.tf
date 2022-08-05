output "id" {
  value       = azurerm_log_analytics_workspace.main.id
  description = "The Log Analytics Workspace ID"
}

output "primary_shared_key" {
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  description = "The Primary shared key for the Log Analytics Workspace"
}

output "secondary_shared_key" {
  value       = azurerm_log_analytics_workspace.main.secondary_shared_key
  description = "The Secondary shared key for the Log Analytics Workspace"
}

output "workspace_id" {
  value       = azurerm_log_analytics_workspace.main.workspace_id
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace"
}

output "workspace_name" {
  value       = azurerm_log_analytics_workspace.main.name
  description = "The Workspace Name for the Log Analytics Workspace"
}

output "location" {
  value       = azurerm_log_analytics_workspace.main.location
  description = "The Workspace ID for the Log Analytics Workspace"
}

output "resource_group_name" {
  value = azurerm_log_analytics_workspace.main.resource_group_name

}
