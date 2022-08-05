resource "azurerm_policy_definition" "sql_naming" {
  name                  = "sqlDbNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for Azure SQL Databases"
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
                "equals": "Microsoft.Sql/servers/databases"
            },
            {
                "not": {
                    "anyOf": [
                        {
                            "allOf": [
                                {
                                    "value": "[equals(length(split(parameters('sqlPattern'), '-')), length(split(field('name'), '-')))]",
                                    "equals": true
                                },
                                {
                                    "value": "[equals(toLower(first(split(parameters('sqlPattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                                    "equals": true
                                },
                                {
                                    "value": "[last(split(field('name'), '-'))]",
                                    "match": "[last(split(parameters('sqlPattern'), '-'))]"
                                }
                            ]
                        },
                        {
                            "allOf": [
                                {
                                    "value": "[equals(length(split(parameters('sqlStrPattern'), '-')), length(split(field('name'), '-')))]",
                                    "equals": true
                                },
                                {
                                    "value": "[equals(toLower(first(split(parameters('sqlStrPattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                                    "equals": true
                                },
                                {
                                    "value": "[last(split(field('name'), '-'))]",
                                    "match": "[last(split(parameters('sqlStrPattern'), '-'))]"
                                }
                            ]
                        },
                        {
                            "allOf": [
                                {
                                    "value": "[equals(length(split(parameters('sqlDwPattern'), '-')), length(split(field('name'), '-')))]",
                                    "equals": true
                                },
                                {
                                    "value": "[equals(toLower(first(split(parameters('sqlDwPattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                                    "equals": true
                                },
                                {
                                    "value": "[last(split(field('name'), '-'))]",
                                    "match": "[last(split(parameters('sqlDwPattern'), '-'))]"
                                }
                            ]
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
  "sqlPattern": {
    "type": "String",
    "metadata": {
      "displayName": "SQL Pattern",
      "description": "SQL Pattern to check for naming convention"
    }
  },
  "sqlStrPattern": {
    "type": "String",
    "metadata": {
      "displayName": "SQL Stretch Pattern",
      "description": "SQL Stretch Pattern to check for naming convention"
    }
  },
  "sqlDwPattern": {
    "type": "String",
    "metadata": {
      "displayName": "SQL DW Pattern",
      "description": "SQL DW Pattern to check for naming convention"
    }
  }
}
PARAMETERS
}
