resource "azurerm_policy_definition" "deny_all_inbound" {
  name                  = "bupa-deny-all-inbound"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Deny NSG rule with allow all inbound"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Network"
  }
METADATA

  policy_rule = <<POLICY_RULE
{
    "if": {
        "allOf": [
            {
                "field": "type",
                "equals": "Microsoft.Network/networkSecurityGroups/securityRules"
            },
            {
                "allOf": [
                    {
                        "field": "Microsoft.Network/networkSecurityGroups/securityRules/access",
                        "equals": "Allow"
                    },
                    {
                        "field": "Microsoft.Network/networkSecurityGroups/securityRules/direction",
                        "equals": "Inbound"
                    },
                    {
                        "anyOf": [
                            {
                                "field": "Microsoft.Network/networkSecurityGroups/securityRules/destinationPortRange",
                                "equals": "*"
                            },
                            {
                                "not": {
                                    "field": "Microsoft.Network/networkSecurityGroups/securityRules/destinationPortRanges[*]",
                                    "notEquals": "*"
                                }
                            }
                        ]
                    },
                    {
                        "anyOf": [
                            {
                                "field": "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefix",
                                "in": [
                                    "*",
                                    "Internet"
                                ]
                            },
                            {
                                "not": {
                                    "field": "Microsoft.Network/networkSecurityGroups/securityRules/sourceAddressPrefixes[*]",
                                    "notIn": [
                                        "*",
                                        "Internet"
                                    ]
                                }
                            }
                        ]
                    }
                ]
            }
        ]
    },
    "then": {
        "effect": "deny"
    }
}
POLICY_RULE
}
