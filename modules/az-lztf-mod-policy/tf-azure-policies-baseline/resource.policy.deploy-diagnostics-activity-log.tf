resource "azurerm_policy_definition" "deploy_diagnostics_activity_log" {
  name                  = "deployDiagnosticsActivityLog"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Deploy Diagnostics ActivityLog"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Monitoring"
  }
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Resources/subscriptions"
      }
    ]
  },
  "then": {
    "effect": "deployIfNotExists",
    "details": {
      "type": "Microsoft.Insights/diagnosticSettings",
      "deploymentScope": "Subscription",
      "existenceScope": "Subscription",
      "existenceCondition": {
        "allOf": [
          {
            "field": "Microsoft.Insights/diagnosticSettings/logs.enabled",
            "equals": "true"
          },
          {
            "field": "Microsoft.Insights/diagnosticSettings/workspaceId",
            "equals": "[parameters('logAnalytics')]"
          }
        ]
      },
      "deployment": {
        "location": "eastus",
        "properties": {
          "mode": "incremental",
          "template": {
            "$schema": "https://schema.management.azure.com/schemas/2018-05-01/subscriptionDeploymentTemplate.json#",
            "contentVersion": "1.0.0.0",
            "parameters": {
              "logAnalytics": {
                "type": "string"
              }
            },
            "variables": {},
            "resources": [
              {
                "name": "subscriptionLogsToLogAnalytics",
                "type": "Microsoft.Insights/diagnosticSettings",
                "apiVersion": "2017-05-01-preview",
                "location": "Global",
                "properties": {
                  "workspaceId": "[parameters('logAnalytics')]",
                  "logs": [
                    {
                      "category": "Administrative",
                      "enabled": true
                    },
                    {
                      "category": "Security",
                      "enabled": true
                    },
                    {
                      "category": "ServiceHealth",
                      "enabled": true
                    },
                    {
                      "category": "Alert",
                      "enabled": true
                    },
                    {
                      "category": "Recommendation",
                      "enabled": true
                    },
                    {
                      "category": "Policy",
                      "enabled": true
                    },
                    {
                      "category": "Autoscale",
                      "enabled": true
                    },
                    {
                      "category": "ResourceHealth",
                      "enabled": true
                    }
                  ]
                }
              }
            ],
            "outputs": {}
          },
          "parameters": {
            "logAnalytics": {
              "value": "[parameters('logAnalytics')]"
            }
          }
        }
      },
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
      ]
    }
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "logAnalytics": {
    "type": "String",
    "metadata": {
      "displayName": "Primary Log Analytics workspace",
      "description": "Select Log Analytics workspace from dropdown list",
      "strongType": "omsWorkspace"
    }
  }
}
PARAMETERS
}
