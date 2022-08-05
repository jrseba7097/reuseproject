resource "azurerm_policy_definition" "deploy_storage_advanced_threat" {
  name                  = "bupa-deploy-storage-advanced-threat"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Bupa - Deploy storage account advanced threat protection"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Storage"
  }
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "field": "type",
    "equals": "Microsoft.Storage/storageAccounts"
  },
  "then": {
    "effect": "[parameters('effect')]",
    "details": {
      "type": "Microsoft.Security/advancedThreatProtectionSettings",
      "name": "current",
      "existenceCondition": {
        "field": "Microsoft.Security/advancedThreatProtectionSettings/isEnabled",
        "equals": "true"
      },
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/fb1c8493-542b-48eb-b624-b4c8fea62acd"
      ],
      "deployment": {
        "properties": {
          "mode": "incremental",
          "template": {
            "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "storageAccountName": {
                "type": "string"
              }
            },
            "resources": [
              {
                "apiVersion": "2019-01-01",
                "type": "Microsoft.Storage/storageAccounts/providers/advancedThreatProtectionSettings",
                "name": "[concat(parameters('storageAccountName'), '/Microsoft.Security/current')]",
                "properties": {
                  "isEnabled": true
                }
              }
            ]
          },
          "parameters": {
            "storageAccountName": {
              "value": "[field('name')]"
            }
          }
        }
      }
    }
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "effect": {
    "type": "String",
    "metadata": {
      "displayName": "Effect",
      "description": "Enable or disable the execution of the policy"
    },
    "allowedValues": [
      "DeployIfNotExists",
      "Disabled"
    ],
    "defaultValue": "Disabled"
  }
}
PARAMETERS
}
