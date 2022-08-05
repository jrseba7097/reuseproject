resource "azurerm_policy_definition" "stg_acc_naming" {
  name                  = "stgAccNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for Storage Accounts"
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
                "equals": "Microsoft.Storage/storageAccounts"
            },
            {
                "not":
                {
                    "value": "[substring(field('name'), 0, 2)]",
                    "equals": "[substring(parameters('namePattern'), 0, 2)]"
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
