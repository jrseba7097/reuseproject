variable "resource_group_name" {
  description = "The name of the resource group in which to create the Bastion Host"
  type        = string
}

variable "location" {
  description = "The full (Azure) location identifier for the Resource Group"
  type        = string
}

variable "name" {
  description = "Name to assign to the Bastion host.Changing this forces a new resource to be created"
  type        = string
}

variable "ip_configuration_name" {
  description = "Name to assign to the IP configuration"
  type        = string
}

variable "subnet_id" {
  description = "Reference to a subnet in which this Bastion Host has been created"
  type        = string
}

variable "public_ip_name" {
  description = "Name to assign to the Public IP"
  type        = string
}

variable "allocation_method" {
  description = "Defines the allocation method for this IP address. Possible values are Static or Dynamic"
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic"
  type        = string
  default     = "Basic"
}
