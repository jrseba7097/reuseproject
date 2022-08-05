resource "azurerm_network_security_rule" "rules" {
  count = length(var.rules)

  name                                       = try(var.rules[count.index].name, null)
  priority                                   = try(var.rules[count.index].priority, null)
  direction                                  = try(var.rules[count.index].direction, null)
  access                                     = try(var.rules[count.index].access, null)
  protocol                                   = try(var.rules[count.index].protocol, null)
  source_port_range                          = try(var.rules[count.index].source_port_range, null)
  source_port_ranges                         = try(var.rules[count.index].source_port_ranges, null)
  destination_port_range                     = try(var.rules[count.index].destination_port_range, null)
  destination_port_ranges                    = try(var.rules[count.index].destination_port_ranges, null)
  source_address_prefix                      = try(var.rules[count.index].source_address_prefix, null)
  source_address_prefixes                    = try(var.rules[count.index].source_address_prefixes, null)
  destination_address_prefix                 = try(var.rules[count.index].destination_address_prefix, null)
  destination_address_prefixes               = try(var.rules[count.index].destination_address_prefixes, null)
  source_application_security_group_ids      = try(var.rules[count.index].source_application_security_group_ids, null)
  destination_application_security_group_ids = try(var.rules[count.index].destination_application_security_group_ids, null)
  description                                = try(var.rules[count.index].description, null)

  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.main.name
}
