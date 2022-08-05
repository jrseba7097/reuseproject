resource "azurerm_public_ip" "bastion_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = var.allocation_method
  sku                 = var.sku

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
