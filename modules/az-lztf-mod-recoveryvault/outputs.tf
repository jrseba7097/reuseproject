output "id" {
  value       = azurerm_recovery_services_vault.main.id
  description = "The ID of the Recovery Services Vault"
}

output "policy_ids" {
  value       = azurerm_backup_policy_vm.policies.*.id
  description = "The ID of the VM Backup Policies"
}

output "policy_names" {
  value       = azurerm_backup_policy_vm.policies.*.name
  description = "The name of the VM Backup Policies"
}

output "recovery_vault_name" {
  value       = azurerm_recovery_services_vault.main.name
  description = "The name of the Recovery Services Vault"
}

output "name" {
  value       = azurerm_recovery_services_vault.main.name
  description = "The name of the Recovery Services Vault"
}



output "resource_group_name" {
  value       = azurerm_recovery_services_vault.main.resource_group_name
  description = "The resource group name of the Recovery Services Vault"
}

output "sku" {
  value       = azurerm_recovery_services_vault.main.sku
  description = "The sku of the Recovery Services Vault"
}

output "location" {
  value       = azurerm_recovery_services_vault.main.location
  description = "The location of the Recovery Services Vault"
}
