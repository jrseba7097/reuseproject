variable "name" {
  description = "Name of the KeyVault"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name for the KeyVault"
  type        = string
}

variable "location" {
  description = "List of organisation wise approved region for workload deployment"
  type        = string
}

variable "enabled_for_deployment" {
  description = "Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false"
  type        = bool
  default     = false
}

variable "enabled_for_template_deployment" {
  description = "Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false"
  type        = bool
  default     = false
}

variable "enable_rbac_authorization" {
  description = "Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false"
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted"
  type        = number
  default     = 90
}

variable "purge_protection_enabled" {
  description = "Is Purge Protection enabled for this Key Vault? Defaults to false"
  type        = bool
  default     = true
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault"
  type        = string
}

variable "sku_name" {
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium"
  type        = string
  default     = "standard"
}

variable "default_action" {
  description = "The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny"
  type        = string
  default     = "Deny"
}

variable "bypass" {
  description = "Specifies which traffic can bypass the network rules. Possible values are AzureServices and None"
  type        = string
}

variable "allowed_ip_ranges" {
  description = "One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault"
  type        = list(any)
  default     = []
}

variable "allowed_virtual_network_subnet_ids" {
  description = "A list of resource ids for subnets"
  type        = list(any)
  default     = []
}

variable "enable_logs" {
  description = "Deploy diagnostic settings true/false"
  type        = string
  default     = "false"
}

variable "diag_name" {
  description = "The diagnostic setting name"
  type        = string
  default     = ""
}

variable "storage_account_id" {
  description = "Storage account ID to use for the logs"
  type        = string
  default     = ""
}

variable "retention_days" {
  description = "The number of days for which this Retention Policy should apply for logging"
  type        = number
  default     = 365
}

variable "log_analytics_workspace_id" {
  description = "(Optional) Log analytics workspace ID to use for the logs"
  type        = string
  default     = null
}
