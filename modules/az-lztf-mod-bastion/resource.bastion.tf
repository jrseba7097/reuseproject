resource "azurerm_bastion_host" "bastion" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.ip_configuration_name
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
