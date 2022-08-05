resource "azurerm_backup_policy_vm" "policies" {
  count = length(var.policies)

  name                = var.policies[count.index].name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.main.name

  timezone = var.policies[count.index].timezone


  instant_restore_retention_days = var.policies[count.index].instant_restore_retention_days

  backup {
    frequency = var.policies[count.index].frequency
    time      = var.policies[count.index].time
    weekdays  = try(var.policies[count.index].weekdays,[])
  }

  dynamic "retention_daily" {
    for_each = var.policies[count.index].retention_daily_count != null ? [1] : []
    content {
      count = var.policies[count.index].retention_daily_count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.policies[count.index].retention_weekly_count != null ? [1] : []
    content {
      count    = var.policies[count.index].retention_weekly_count
      weekdays = var.policies[count.index].retention_weekly_days
    }
  }

  dynamic "retention_monthly" {
    for_each = var.policies[count.index].retention_monthly_count != null ? [1] : []
    content {
      count    = var.policies[count.index].retention_monthly_count
      weekdays = var.policies[count.index].retention_monthly_days
      weeks    = var.policies[count.index].retention_monthly_weeks
    }
  }

  dynamic "retention_yearly" {
    for_each = var.policies[count.index].retention_yearly_count != null ? [1] : []
    content {
      count    = var.policies[count.index].retention_yearly_count
      weekdays = var.policies[count.index].retention_yearly_days
      weeks    = var.policies[count.index].retention_yearly_weeks
      months   = var.policies[count.index].retention_yearly_months
    }
  }
}
