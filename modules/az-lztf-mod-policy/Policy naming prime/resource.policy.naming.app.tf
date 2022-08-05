resource "azurerm_policy_definition" "app_naming" {
  name                  = "appNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for App Services"
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
                "equals": "Microsoft.Web/sites"
            },
            {
                "not": {
                    "anyOf": [
                        {
                            "allOf": [
                                {
                                    "value": "[equals(length(split(parameters('appPattern'), '-')), length(split(field('name'), '-')))]",
                                    "equals": true
                                },
                                {
                                    "value": "[equals(toLower(first(split(parameters('appPattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                                    "equals": true
                                },
                                {
                                    "value": "[last(split(field('name'), '-'))]",
                                    "match": "[last(split(parameters('appPattern'), '-'))]"
                                }
                            ]
                        },
                        {
                            "allOf": [
                                {
                                    "value": "[equals(length(split(parameters('funcPattern'), '-')), length(split(field('name'), '-')))]",
                                    "equals": true
                                },
                                {
                                    "value": "[equals(toLower(first(split(parameters('funcPattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                                    "equals": true
                                },
                                {
                                    "value": "[last(split(field('name'), '-'))]",
                                    "match": "[last(split(parameters('funcPattern'), '-'))]"
                                }
                            ]
                        },
                        {
                            "allOf": [
                                {
                                    "value": "[equals(length(split(parameters('csPattern'), '-')), length(split(field('name'), '-')))]",
                                    "equals": true
                                },
                                {
                                    "value": "[equals(toLower(first(split(parameters('csPattern'), '-'))), toLower(first(split(field('name'), '-'))))]",
                                    "equals": true
                                },
                                {
                                    "value": "[last(split(field('name'), '-'))]",
                                    "match": "[last(split(parameters('csPattern'), '-'))]"
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
  "appPattern": {
    "type": "String",
    "metadata": {
      "displayName": "App Pattern",
      "description": "App Pattern to check for naming convention"
    }
  },
  "funcPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Function Pattern",
      "description": "Function Pattern to check for naming convention"
    }
  },
  "csPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Cloud services Pattern",
      "description": "Cloud services Pattern to check for naming convention"
    }
  }
}
PARAMETERS
}
