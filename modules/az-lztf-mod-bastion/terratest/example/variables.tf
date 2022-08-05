variable "name" {
  description = "Name of the Bastion Host"
  type        = string
  default     = "BASTION-cose-eun-SemiTrustTestSpoke-Test"
}

variable "resource_group_name" {
  description = "Resource Group Name for the Bastion"
  type        = string
  default     = "RG-cose-eun-SemiTrustTestSpoke"
}

variable "location" {
  description = "List of organisation wise approved region for workload deployment"
  type        = string
  default     = "northeurope"
}

variable "ip_configuration_name" {
  description = "Name to assign to the IP configuration"
  type        = string
  default     = "bastion_configuration"
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
  default     = "VNET-cose-eun-SemiTrustTestSpoke"
}

variable "subnet_name" {
  description = "The name of the subnet for the Bastion"
  default     = "AzureBastionSubnet"
}

variable "address_prefix" {
  description = "The address prefix"
  default     = "192.168.1.0/24"
}

variable "public_ip_name" {
  description = "Name to assign to the Public IP"
  type        = string
  default     = "PIP-public-ip-test"
}
