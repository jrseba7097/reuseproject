variable "management_groups" {
  type = object({
    name             = string
    display_name     = string
    subscription_ids = list(string)
    children         = list(any)
  })
  description = "Management groups hierarchy"
  default = {
    children         = []
    display_name     = "Test Management Groups"
    name             = "TestManagementGroup"
    subscription_ids = []
  }
}

variable "parent_management_group_id" {
  type        = string
  description = "Management group id where the MG hierarchy starts"
  default     = "/providers/Microsoft.Management/managementGroups/CloudTechServ"
}
