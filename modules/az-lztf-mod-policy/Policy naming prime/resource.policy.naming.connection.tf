resource "azurerm_policy_definition" "connection_naming" {
  name                  = "connectionNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for connections"
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
                "equals": "Microsoft.Network/connections"
            },
            {
                "not":
                {
                    "value": "[equals(first(split(parameters('namePattern'), '-')), first(split(field('name'), '-')))]",
                    "equals": true
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
  "namePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Pattern",
      "description": "Pattern to check for naming convention"
    }
  }
}
PARAMETERS
}
