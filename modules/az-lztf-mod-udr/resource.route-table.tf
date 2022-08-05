resource "azurerm_route_table" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  disable_bgp_route_propagation = var.disable_bgp_route_propagation

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_subnet_route_table_association" "main" {
  count = length(var.subnet_ids)

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = azurerm_route_table.main.id

  lifecycle {
    ignore_changes = [
      route_table_id, # Added to enable import
    ]
  }
}
