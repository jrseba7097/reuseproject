variable "mandatory_tag_keys" {
  type        = list(string)
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG'"
  default = [
    "Owner ID",
    "Billing",
    "IT Service",
    "ENV",
    "Project"
  ]
}

variable "mandatory_tag_value" {
  type        = string
  description = "Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG'"
  default     = "TBC"
}

variable "policy_definition_category" {
  type        = string
  description = "The category to use for all Policy Definitions"
  default     = "Custom"
}

variable "holder_management_group_name" {
  type        = string
  description = "Management group name to store policies"
}
