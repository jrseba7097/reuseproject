variable "location" {
  description = "The full (Azure) location identifier for the policy"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group to deploy the policy to"
  type        = string
}

variable "policy_name" {
  description = "Name to deploy policy with"
  type        = string
}

variable "fw_threat_intel_mode" {
  description = "The firewall operation mode for threat intelligence-based filtering. Possible values are: Off, Alert and Deny. Defaults to Alert"
  default     = "Alert"
}

variable "fw_network_rules" {
  type        = list
  description = "List that manages Network Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "fw_application_rules" {
  type        = list
  description = "List that manages Application Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "fw_nat_rules" {
  type        = list
  description = "List that manages Nat Rule Collections within an Azure Firewall Policy"
  default     = []
}

variable "tags" {
  type        = map
  description = "Map of tags to assign the module components"
  default     = {}
}
