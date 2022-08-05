resource "azurerm_policy_set_definition" "main" {
  name                  = "baselinePolicySet"
  policy_type           = "Custom"
  display_name          = "Baseline Policy Set"
  management_group_name = var.holder_management_group_name

  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }
        },
        "deniedResources": {
            "type": "Array",
            "metadata": {
                "description": "The list of resource types that cannot be deployed.",
                "displayName": "Not allowed resource types",
                "strongType": "resourceTypes"
            },
            "defaultValue": []
        },
        "logAnalyticsRGName": {
            "type": "String",
            "metadata": {
                "description": "The resource group name where the export to Log Analytics workspace configuration is created. If you enter a name for a resource group that doesn't exist, it'll be created in the subscription. Note that each resource group can only have one export to Log Analytics workspace configured.",
                "displayName": "Log Analytics resource group name"
            },
            "defaultValue": ""
        },
        "logAnalyticsLocation": {
            "type": "String",
            "metadata": {
                "description": "The location where the resource group and the export to Log Analytics workspace configuration are created.",
                "displayName": "Log Analytics resource group location",
                "strongType": "location"
            },
            "defaultValue": ""
        },
        "logAnalyticsId": {
            "type": "String",
            "metadata": {
                "description": "The Log Analytics workspace of where the data should be exported to. If you do not already have a log analytics workspace, visit Log Analytics workspaces to create one (https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.OperationalInsights%2Fworkspaces).",
                "displayName": "Log Analytics workspace",
                "strongType": "Microsoft.OperationalInsights/workspaces"
            },
            "defaultValue": ""
        }
    }
PARAMETERS

  # Allowed-ResourceLocation
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }

  # Allowed-RGLocation
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }

  # Require-Tags
  dynamic "policy_definition_reference" {
    for_each = [for tag in var.required_tags : {
      tagName    = tag
      tagToCheck = var.tag_exception.name
      tagValue   = var.tag_exception.value
    }]

    content {
      policy_definition_id = azurerm_policy_definition.require_rg_tag.id
      parameter_values     = <<VALUE
      {
        "tagName": {"value": "${policy_definition_reference.value.tagName}"},
        "tagToCheck": {"value": "${policy_definition_reference.value.tagToCheck}"},
        "tagValue": {"value": "${policy_definition_reference.value.tagValue}"}
      }
      VALUE
    }
  }

  # Inherit-RGTags
  dynamic "policy_definition_reference" {
    for_each = [for tag in var.required_tags : {
      tagName = tag
    }]

    content {
      policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ea3f2387-9b95-492a-a190-fcdc54f7b070"
      parameter_values     = <<VALUE
      {
        "tagName": {"value": "${policy_definition_reference.value.tagName}"}
      }
      VALUE
    }
  }

  # Denied-Resources
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/6c112d4e-5bc7-47ae-a041-ea2d9dccd749"
    parameter_values     = <<VALUE
    {
      "listOfResourceTypesNotAllowed": {"value": "[parameters('deniedResources')]"}
    }
    VALUE
  }

  # Deny-AppGW-Without-WAF
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/564feb30-bf6a-4854-b4bb-0d2d2d1e6c66"
    parameter_values     = <<VALUE
    {
      "effect": {"value": "Deny"}
    }
    VALUE
  }

  # Deny-IP-Forwarding
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900"
  }

  # Deny-RDP-From-Internet
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deny_rdp.id
    parameter_values     = <<VALUE
    {
      "effect": {"value": "Deny"}
    }
    VALUE
  }

  # Audit-Subnet-Without-Nsg
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.audit_subnet_without_nsg.id
  }

  # Deploy-ASC-CE
  policy_definition_reference {
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ffb6f416-7bd2-4488-8828-56585fef2be9"
    parameter_values     = <<VALUE
    {
      "resourceGroupName": {"value": "[parameters('logAnalyticsRGName')]"},
      "resourceGroupLocation": {"value": "[parameters('logAnalyticsLocation')]"},
      "workspaceResourceId": {"value": "[parameters('logAnalyticsId')]"}
    }
    VALUE
  }

  # Deploy-ASC-Standard
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deploy_asc_standard.id
  }

  # Deploy-Diag-ActivityLog
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.deploy_diagnostics_activity_log.id
    parameter_values     = <<VALUE
    {
      "logAnalytics": {"value": "[parameters('logAnalyticsId')]"}
    }
    VALUE
  }
}
