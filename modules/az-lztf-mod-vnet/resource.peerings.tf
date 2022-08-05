resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  count = length(var.peerings)

  provider = azurerm.hub

  name                         = var.peerings[count.index].name_to_spoke
  resource_group_name          = var.peerings[count.index].hub_resource_group_name
  virtual_network_name         = var.peerings[count.index].hub_vnet_name
  remote_virtual_network_id    = azurerm_virtual_network.main.id
  allow_virtual_network_access = var.peerings[count.index].allow_vnet_access_hub_spoke
  allow_forwarded_traffic      = var.peerings[count.index].allow_forwarded_traffic_hub_spoke
  allow_gateway_transit        = var.peerings[count.index].allow_gateway_transit_hub_spoke
  use_remote_gateways          = var.peerings[count.index].use_remote_gateways_hub_spoke
}

resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  count = length(var.peerings)

  name                         = var.peerings[count.index].name_to_hub
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.main.name
  remote_virtual_network_id    = var.peerings[count.index].hub_vnet_id
  allow_virtual_network_access = var.peerings[count.index].allow_vnet_access_spoke_hub
  allow_forwarded_traffic      = var.peerings[count.index].allow_forwarded_traffic_spoke_hub
  allow_gateway_transit        = var.peerings[count.index].allow_gateway_transit_spoke_hub
  use_remote_gateways          = var.peerings[count.index].use_remote_gateways_spoke_hub
}
