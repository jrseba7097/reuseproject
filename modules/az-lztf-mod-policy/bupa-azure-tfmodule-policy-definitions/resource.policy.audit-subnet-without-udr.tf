resource "azurerm_policy_definition" "audit_subnet_udr" {
  name                  = "bupa-audit-subnet-udr"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Ensure User-Defined-Route Table in every new subnet"
  description           = "Ensure User-Defined-Route Table in every new subnet"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
{
  "version": "1.1.0",
  "category": "Network"
}
METADATA

  policy_rule = <<POLICYRULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Network/virtualNetworks/subnets"
      },
      {
        "field": "name",
        "notIn": "[parameters('excludedSubnets')]"
      },
      {
        "field": "Microsoft.Network/virtualNetworks/subnets/routeTable.id",
        "exists": "false"
      }
    ]
  },
  "then": {
    "effect": "[parameters('effect')]"
  }
}
POLICYRULE

  parameters = <<PARAMETERS
{
  "effect": {
    "type": "String",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    },
    "allowedValues": [
      "Audit",
      "Deny",
      "Disabled"
    ],
    "defaultValue": "Audit"
  },
  "excludedSubnets": {
    "type": "Array",
    "metadata": {
      "displayName": "Excluded Subnets",
      "description": "Array of subnet names that are excluded from this policy"
    },
    "defaultValue": [
      "AzureBastionSubnet"
    ]
  }
}
PARAMETERS

}
