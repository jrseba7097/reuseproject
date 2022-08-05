variable "holder_management_group_name" {
  type        = string
  description = "Management group name to store policies"
  default     = "CloudTechServ"
}

variable "scope_id" {
  type        = string
  description = "Scope"
  default     = "/providers/Microsoft.Management/managementGroups/CloudTechServ"
}
