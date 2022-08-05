resource "azurerm_backup_protected_vm" "backup_protected_vm" {
  count = length(var.protected_vms)

  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name
  source_vm_id        = var.protected_vms[count.index].source_vm_id
  backup_policy_id    = azurerm_backup_policy_vm.policies[var.protected_vms[count.index].policy_index].id

  lifecycle {
    ignore_changes = [
      source_vm_id
    ]
  }
}
