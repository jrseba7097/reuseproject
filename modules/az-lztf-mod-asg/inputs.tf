variable "resource_group_name" {
  description = "Resource Group to deploy the ASG to"
  type        = string
}

variable "location" {
  description = "The full (Azure) location identifier for the ASG"
  type        = string
}

variable "name" {
  description = "Specifies the name of the application security group. Changing this forces a new resource to be created"
  type        = string
}

variable "network_interface_id" {
  description = "List of IDs of the Network Interfaces to associate."
  type        = list(string)
  default     = []
}
