variable "workspace_name" {
  description = "Name of the Log Analytics Workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name for  the Log Analytics Workspace"
  type        = string
}

variable "location" {
  description = "List of organisation wise approved region for workload deployment"
  type        = string
}

variable "workspace_sku" {
  description = "Tier for the Log Analytics Workspace"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_days" {
  description = "Retention period for data within the Log Analytics Workspace"
  type        = number
  default     = 365
}

variable "solutions" {
  default     = []
  description = "List of Log Analytics Solutions to enable in the Log Analytics Workspace"
}

variable "linked_storage_accounts" {
  default     = []
  description = "List of storage accounts to link with the Log Analytics Workspace"
}
