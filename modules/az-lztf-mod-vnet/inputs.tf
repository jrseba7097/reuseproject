variable "resource_group_name" {
  description = "Resource Group where the is vnet is deployed to"
  type        = string
}

variable "location" {
  description = "The full (Azure) location identifier for vnet"
  type        = string
}

variable "vnet_name" {
  description = "Name to deploy vnet with"
  type        = string
}

variable "address_spaces" {
  description = "List of the full VNet CIDR ranges for VNet"
  type        = list(any)
}

variable "dns_servers" {
  description = "The IP address of the DNS server to be given on the primary subnet via DHCP"
  type        = list(any)
  default     = []
}

variable "subnets" {
  description = "List of objects to configure subnets in Vnet"
  type        = list(any)
  default     = []
}

variable "peerings" {
  description = "List of objects to configure peerings in Vnet"
  type        = list(any)
  default     = []
}

variable "ddos_protection_plan_id" {
  description = "Ddos protection plan id to be used in the VNET if enabled"
  type        = string
}
