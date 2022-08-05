# variable "master_mg_name" {
#   description = "The name for master Management Group, which needs to be unique across your tenant"
#   type        = string
# }
# variable "master_mg_display_name" {
#   description = "A friendly name for master Management Group"
#   type        = string
# }
# variable "tier1_manangement_groups" {
#   description = "List of management groups to create under master"
#   type        = list
# }
# variable "tier2_manangement_groups" {
#   description = "List of management groups to create under tier1"
#   type        = list
# }

variable "management_groups" {
  type = any
}

variable "parent_management_group_id" {
  type = string
  default = null
}