resource "azurerm_application_security_group" "asg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_network_interface_application_security_group_association" "asg_assoc" {
  count = length(var.network_interface_id)

  network_interface_id          = var.network_interface_id[count.index]
  application_security_group_id = azurerm_application_security_group.asg.id
}
