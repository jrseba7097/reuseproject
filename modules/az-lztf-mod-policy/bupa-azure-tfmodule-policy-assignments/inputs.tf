variable "name" {
  type        = string
  description = "The policy assignment name"
}

variable "display_name" {
  type        = string
  description = "The policy assignment display name"
}

variable "description" {
  type        = string
  description = "The policy assignment description"
}

variable "policy_definition_id" {
  type        = string
  description = "The policy definition id"
}

variable "scope" {
  type        = string
  description = "The policy assignment scope id"
}

variable "location" {
  type        = string
  description = "The policy assignment location, needed if identity is enabled"
  default     = null
}

variable "enable_identity" {
  type        = bool
  description = "Enable policy assignment identity"
  default     = false
}

variable "metadata" {
  type        = string
  description = "The policy assignment metadata"
  default     = null
}

variable "parameters" {
  type        = string
  description = "The policy assignment parameters"
  default     = null
}
