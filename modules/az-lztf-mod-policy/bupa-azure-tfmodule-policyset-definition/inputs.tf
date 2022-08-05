variable "name" {
  type        = string
  description = "The name of the policy set definition."
}

variable "policy_type" {
  type        = string
  description = "The policy set type."
  default     = "Custom"
}

variable "display_name" {
  type        = string
  description = "The display name of the policy set definition."
}

variable "description" {
  type        = string
  description = "The description of the policy set definition."
}

variable "policyset_definition_category" {
  type        = string
  description = "The category to use for the PolicySet metadata"
  default     = "Custom"
}

variable "policies" {
  type        = list(map(string))
  description = "List of policy definitions ids and their parameters"
}

variable "parameters" {
  type        = string
  description = "Policy set parameters"
}

variable "holder_management_group_name" {
  type        = string
  description = "Management group name to store policies"
}
