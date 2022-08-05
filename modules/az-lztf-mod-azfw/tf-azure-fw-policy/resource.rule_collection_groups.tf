resource "azurerm_firewall_policy_rule_collection_group" "nat" {
  count = length(var.fw_nat_rules)

  name               = "${var.policy_name}-rcg-nat-${count.index + 1}"
  firewall_policy_id = azurerm_firewall_policy.main.id
  priority           = (100 + count.index)

  nat_rule_collection {
    name     = var.fw_nat_rules[count.index].name
    priority = var.fw_nat_rules[count.index].priority
    action   = var.fw_nat_rules[count.index].action

    dynamic "rule" {
      for_each = [for rule in var.fw_nat_rules[count.index].rules : {
        name                = rule.name
        source_addresses    = rule.source_addresses
        destination_ports   = rule.destination_ports
        destination_address = rule.destination_address
        translated_port     = rule.translated_port
        translated_address  = rule.translated_address
        protocols           = rule.protocols
      }]

      content {
        name                = rule.value.name
        source_addresses    = rule.value.source_addresses
        destination_ports   = rule.value.destination_ports
        destination_address = rule.value.destination_address
        translated_port     = rule.value.translated_port
        translated_address  = rule.value.translated_address
        protocols           = rule.value.protocols
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "network" {
  count = length(var.fw_network_rules)

  name               = "${var.policy_name}-rcg-net-${count.index + 1}"
  firewall_policy_id = azurerm_firewall_policy.main.id
  priority           = (200 + count.index)

  network_rule_collection {
    name     = var.fw_network_rules[count.index].name
    priority = var.fw_network_rules[count.index].priority
    action   = var.fw_network_rules[count.index].action

    dynamic "rule" {
      for_each = [for rule in var.fw_network_rules[count.index].rules : {
        name                  = rule.name
        source_addresses      = rule.source_addresses
        destination_ports     = rule.destination_ports
        destination_addresses = rule.destination_addresses
        protocols             = rule.protocols
      }]

      content {
        name                  = rule.value.name
        source_addresses      = rule.value.source_addresses
        destination_ports     = rule.value.destination_ports
        destination_addresses = rule.value.destination_addresses
        protocols             = rule.value.protocols
      }
    }
  }
}

resource "azurerm_firewall_policy_rule_collection_group" "application" {
  count = length(var.fw_application_rules)

  name               = "${var.policy_name}-rcg-app-${count.index + 1}"
  firewall_policy_id = azurerm_firewall_policy.main.id
  priority           = (300 + count.index)

  application_rule_collection {
    name     = var.fw_application_rules[count.index].name
    priority = var.fw_application_rules[count.index].priority
    action   = var.fw_application_rules[count.index].action

    dynamic "rule" {
      for_each = [for rule in var.fw_application_rules[count.index].rules : {
        name              = rule.name
        source_addresses  = rule.source_addresses
        destination_fqdns = rule.destination_fqdns
        protocols         = rule.protocols
      }]

      content {
        name              = rule.value.name
        source_addresses  = rule.value.source_addresses
        destination_fqdns = rule.value.destination_fqdns

        dynamic "protocols" {
          for_each = [for protocols in rule.value.protocols : {
            type = protocols.type
            port = protocols.port
          }]

          content {
            type = protocols.value.type
            port = protocols.value.port
          }
        }
      }
    }
  }
}
