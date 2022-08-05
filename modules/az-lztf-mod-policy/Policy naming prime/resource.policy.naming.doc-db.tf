resource "azurerm_policy_definition" "doc_db_naming" {
  name                  = "sqlNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for Azure DocumentDB"
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
                "equals": "Microsoft.DocumentDB/databaseAccounts/sqlDatabases"
            },
            {
                "not": {
                    "allOf": [
                        {
                            "value": "[equals(length(split(parameters('namePattern'), '-')), length(split(field('name'), '-')))]",
                            "equals": true
                        },
                        {
                            "value": "[equals(toLower(first(split(parameters('namePattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                            "equals": true
                        },
                        {
                            "value": "[last(split(field('name'), '-'))]",
                            "match": "[last(split(parameters('namePattern'), '-'))]"
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
