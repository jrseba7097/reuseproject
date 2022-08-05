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

variable "patterns" {
  description = "Name patterns"
}

variable "policyset_definition_category" {
  type        = string
  description = "The category to use for the PolicySet metadata"
  default     = "Custom"
}
