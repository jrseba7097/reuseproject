variable "holder_management_group_name" {
  description = "Management group name to store policies"
  type        = string
}

variable "scope_id" {
  description = "Resource id to assign policies"
  type        = string
}

variable "exceptions" {
  description = "MG, subscription or RG ids to exclude from policies"
  type        = list(string)
  default     = []
}

variable "allowed_locations" {
  description = "The list of locations that can be specified when deploying resources."
  type        = list(string)
}

variable "denied_resources" {
  description = "The list of resource types that cannot be deployed."
  type        = list(string)
  default     = []
}

variable "required_tags" {
  description = "The list of tags required when deploying resources."
  type        = list(string)
}

variable "log_analytics_rg_name" {
  description = "The resource group name where the export to Log Analytics workspace configuration is created. If you enter a name for a resource group that doesn't exist, it'll be created in the subscription. Note that each resource group can only have one export to Log Analytics workspace configured."
  type        = string
}

variable "log_analytics_location" {
  description = "The location where the resource group and the export to Log Analytics workspace configuration are created."
  type        = string
}

variable "log_analytics_id" {
  description = "The Log Analytics workspace of where the data should be exported to. If you do not already have a log analytics workspace, visit Log Analytics workspaces to create one."
  type        = string
}

variable "tag_exception" {
  description = "Tag name and value in parent resource group to skip tag enforcement. Used to enable image creation."
}
