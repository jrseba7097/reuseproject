variable "location" {
  description = "The full (Azure) location identifier for the NSG"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group to deploy the NSG to"
  type        = string
}

variable "name" {
  description = "Specifies the name of the network security group. Changing this forces a new resource to be created"
  type        = string
}

variable "rules" {
  description = "List of objects representing security rules"
  type        = list(any)
}

variable "subnet_ids" {
  description = "List of Subnet ids which should be associated with the NSG"
  type        = list(any)
}

variable "enable_flow_log" {
  description = "Flag to enable Flog logs on NSG"
  type        = bool
  default     = false
}

variable "network_watcher_name" {
  description = "The name of the Network Watcher. Changing this forces a new flow log resource to be created"
  type        = string
  default     = ""
}

variable "network_watcher_resource_group_name" {
  description = "The name of the resource group in which the Network Watcher was deployed. Changing this forces a new flow log resource to be created"
  type        = string
  default     = ""
}

variable "storage_account_id" {
  description = "The ID of the Storage Account where flow logs are stored"
  type        = string
  default     = ""
}

variable "storage_account_logs_enabled" {
  description = "Should Network Flow Logging be Enabled?"
  type        = bool
  default     = true
}

variable "retention_policy_enabled" {
  description = "Boolean flag to enable/disable retention"
  type        = bool
  default     = true
}

variable "retention_policy_days" {
  description = "The number of days to retain flow log records"
  type        = number
  default     = 365
}

variable "traffic_analytics_enabled" {
  description = "Boolean flag to enable/disable traffic analytics"
  type        = bool
  default     = false
}

variable "workspace_id" {
  description = "The resource guid of the attached workspace"
  type        = string
  default     = ""
}

variable "workspace_region" {
  description = "The location of the attached workspace"
  type        = string
  default     = ""
}

variable "workspace_resource_id" {
  description = "The resource ID of the attached workspace"
  type        = string
  default     = ""
}

variable "traffic_analytics_interval_in_minutes" {
  description = "How frequently service should do flow analytics in minutes"
  type        = number
  default     = 60
}

variable "flow_log_version" {
  description = "The version (revision) of the flow log. Possible values are 1 and 2"
  type        = number
  default     = 2
}
