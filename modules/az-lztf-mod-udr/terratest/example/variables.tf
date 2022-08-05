variable "udr_routes" {
  description = "Parameters to configure routes in UDR table"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
}
