resource "azurerm_subnet" "subnets" {
  count = length(var.subnets)

  name                 = var.subnets[count.index].name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.subnets[count.index].address_prefixes
  service_endpoints    = var.subnets[count.index].service_endpoints
}
