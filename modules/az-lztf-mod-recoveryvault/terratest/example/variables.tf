variable "name" {
  description = "Name of the Recovery Vault"
  type        = string
  default = "RSV-test-rsv19960"
}

variable "resource_group_name" {
  description = "Resource Group Name for the Recovery Vault"
  type        = string
  default = "RG-test-rsv19960"
}

variable "location" {
  description = "List of organisation wise approved region for workload deployment"
  type        = string
  default = "westeurope"
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
  type = list(
    object({
      name                           = string
      timezone                       = string
      instant_restore_retention_days = number
      frequency                      = string
      time                           = string
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
  description = "List of Backup policies to use in the Recovery Vault"
}
