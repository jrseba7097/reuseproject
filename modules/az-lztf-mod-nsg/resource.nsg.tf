resource "azurerm_network_security_group" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  count = length(var.subnet_ids)

  subnet_id                 = var.subnet_ids[count.index]
  network_security_group_id = azurerm_network_security_group.main.id
}
