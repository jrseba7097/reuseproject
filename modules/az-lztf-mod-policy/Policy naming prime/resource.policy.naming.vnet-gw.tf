resource "azurerm_policy_definition" "vgw_naming" {
  name                  = "vgwNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for virtual network gateways"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
    {
        "category": "General"
    }
METADATA

  policy_rule = <<POLICY_RULE
{
    "if": {
        "allOf": [
            {
                "field": "type",
                "equals": "Microsoft.Network/virtualNetworkGateways"
            },
            {
                "not": {
                    "anyOf": [
                        {
                            "value": "[equals(first(split(parameters('vpnNamePattern'), '-')), first(split(field('name'), '-')))]",
                            "equals": true
                        },
                        {
                            "value": "[equals(first(split(parameters('erNamePattern'), '-')), first(split(field('name'), '-')))]",
                            "equals": true
                        }
                    ]
                }
            }
        ]
    },
    "then": {
        "effect": "deny"
    }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "vpnNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "VPN Pattern",
      "description": "VPN Pattern to check for naming convention"
    }
  },
  "erNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "ER Pattern",
      "description": "ER Pattern to check for naming convention"
    }
  }
}
PARAMETERS
}
