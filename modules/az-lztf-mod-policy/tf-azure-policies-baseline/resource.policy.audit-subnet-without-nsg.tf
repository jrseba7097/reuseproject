resource "azurerm_policy_definition" "audit_subnet_without_nsg" {
  name                  = "auditSubnetWithoutNSG"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Audit Subnet Without NSG"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Network"
  }
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "anyOf": [
      {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks"
              },
          {
            "not": {
              "field": "Microsoft.Network/virtualNetworks/subnets[*].networkSecurityGroup.id",
              "exists": true
            }
          }
        ]
      },
      {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks/subnets"
          },
          {
            "not": {
              "field": "Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id",
              "exists": true
            }
          }
        ]
      }
    ]
  },
  "then": {
    "effect": "Audit"
  }
}
POLICY_RULE
}
