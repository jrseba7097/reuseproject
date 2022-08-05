
variable "name" {
  type        = string
  description = "The policy assignment name"
    default     = "Security_Governance"
}

variable "policy_definition_id" {
  type        = string
  description = "The policy set definition id"
  default     = "/providers/Microsoft.Authorization/policyDefinitions/b5ec538c-daa0-4006-8596-35468b9148e8"
}

variable "description" {
  type        = string
  default     = "The policy set definition id for security_governance"
}

variable "display_name" {
  type        = string
  description = "The policy assignment display name"
  default     = "Security Governance"
}


variable "scope" {
  type        = string
  description = "Scope"
  default     = "/providers/Microsoft.Management/managementGroups/CloudTechServ"
}

