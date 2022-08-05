variable "location" {
  description = "The full (Azure) location identifier for the route table"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group to deploy the route table to"
  type        = string
}

variable "name" {
  description = "The name of the route table. Changing this forces a new resource to be created"
  type        = string
}

variable "routes" {
  description = "List of objects representing routes"
  type = list(
    object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    })
  )
}

variable "subnet_ids" {
  description = "List of Subnet ids which should be associated with the Route Table"
  type        = list(string)
}

variable "disable_bgp_route_propagation" {
  description = "Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable"
  type        = string
  default     = "true"
}
