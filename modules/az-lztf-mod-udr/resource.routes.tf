resource "azurerm_route" "routes" {
  count = length(var.routes)

  name                   = var.routes[count.index].name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.main.name
  address_prefix         = var.routes[count.index].address_prefix
  next_hop_type          = var.routes[count.index].next_hop_type
  next_hop_in_ip_address = var.routes[count.index].next_hop_in_ip_address
}
