variable "name" {
  description = "Name of the Recovery Vault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name for the Recovery Vault"
  type        = string
}

variable "location" {
  description = "List of organisation wise approved region for workload deployment"
  type        = string
}

variable "soft_delete_enabled" {
  description = "Is soft delete enable for this Vault? Defaults to true"
  type        = bool
  default     = true
}

variable "sku" {
  description = "Sets the vault's SKU. Possible values include: Standard, RS0"
  type        = string
  default     = "Standard"
}

variable "policies" {
  description = "List of Backup policies to use in the Recovery Vault"
  type        = list(
    object({
      name                           = string
      timezone                       = string
      instant_restore_retention_days = number
      frequency                      = string
      time                           = string
      weekdays                       = list(string)
      retention_daily_count          = number
      retention_weekly_count         = number
      retention_weekly_days          = list(string)
      retention_monthly_count        = number
      retention_monthly_days         = list(string)
      retention_monthly_weeks        = list(string)
      retention_yearly_count         = number
      retention_yearly_days          = list(string)
      retention_yearly_weeks         = list(string)
      retention_yearly_months        = list(string)
    })
  )
  default     = []
}

variable "protected_vms" {
  description = "List of Backup protected VMs in the Recovery Vault"
  type        = list(
    object({
      source_vm_id = string
      policy_index = number
    })
  )
  default     = []
}
