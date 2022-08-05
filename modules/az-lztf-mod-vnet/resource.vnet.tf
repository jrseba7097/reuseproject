resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_spaces
  dns_servers         = var.dns_servers

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != "" ? [1] : []

    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
