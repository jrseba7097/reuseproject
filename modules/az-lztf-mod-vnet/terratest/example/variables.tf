variable "vnet" {
  description = "Parameters to configure VNET"
  type = object({
    name                    = string
    address_spaces          = list(string)
    dns_servers             = list(string)
    ddos_protection_plan_id = string
    subnets = list(object({
      name              = string
      address_prefixes  = list(string)
      service_endpoints = list(string)
    }))
    peerings = list(object({
      hub_resource_group_name           = string
      hub_vnet_name                     = string
      hub_vnet_id                       = string
      name_to_spoke                     = string
      allow_vnet_access_hub_spoke       = bool
      allow_forwarded_traffic_hub_spoke = bool
      allow_gateway_transit_hub_spoke   = bool
      use_remote_gateways_hub_spoke     = bool
      name_to_hub                       = string
      allow_vnet_access_spoke_hub       = bool
      allow_forwarded_traffic_spoke_hub = bool
      allow_gateway_transit_spoke_hub   = bool
      use_remote_gateways_spoke_hub     = bool
    }))
  })
}
