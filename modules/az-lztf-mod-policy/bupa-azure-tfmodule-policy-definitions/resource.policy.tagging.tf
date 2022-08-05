resource "azurerm_policy_definition" "addTagToRG" {
  count = length(var.mandatory_tag_keys)

  name                  = "bupa-add-TagToRG_${var.mandatory_tag_keys[count.index]}"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Add tag ${var.mandatory_tag_keys[count.index]} to resource group"
  description           = "Adds the mandatory tag key ${var.mandatory_tag_keys[count.index]} when any resource group missing this tag is created or updated. \nExisting resource groups can be remediated by triggering a remediation task.\nIf the tag exists with a different value it will not be changed."
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
    {
      "category": "${var.policy_definition_category}",
      "version" : "1.0.0"
    }

METADATA

  policy_rule = <<POLICY_RULE
    {
        "if": {
          "allOf": [
            {
              "field": "type",
              "equals": "Microsoft.Resources/subscriptions/resourceGroups"
            },
            {
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "exists": "false"
            },
            {
              "not": {
                "anyOf": [
                  {
                    "value": "[toLower(field('name'))]",
                    "equals": "networkwatcherrg"
                  },
                  {
                    "value": "[first(split(field('name'), '_'))]",
                    "equals": "AzureBackupRG"
                  }
                ]
              }
            }
          ]
        },
        "then": {
          "effect": "modify",
          "details": {
            "roleDefinitionIds": [
              "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "operations": [
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "value": "[parameters('tagValue')]"
              }
            ]
          }
        }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
        "tagName": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
            "description": "Name of the tag, such as ${var.mandatory_tag_keys[count.index]}"
          },
          "defaultValue": "${var.mandatory_tag_keys[count.index]}"
        },
        "tagValue": {
          "type": "String",
          "metadata": {
            "displayName": "Tag Value '${var.mandatory_tag_value}'",
            "description": "Value of the tag, such as '${var.mandatory_tag_value}'"
          },
          "defaultValue": "'${var.mandatory_tag_value}'"
        }
  }
PARAMETERS

}

resource "azurerm_policy_definition" "inheritTagFromRG" {
  count = length(var.mandatory_tag_keys)

  name                  = "bupa-inherit-TagFromRG_${var.mandatory_tag_keys[count.index]}"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Inherit tag ${var.mandatory_tag_keys[count.index]} from the resource group"
  description           = "Adds the specified mandatory tag ${var.mandatory_tag_keys[count.index]} with its value from the parent resource group when any resource missing this tag is created or updated. Existing resources can be remediated by triggering a remediation task. If the tag exists with a different value it will not be changed."
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
        "if": {
          "allOf": [
            {
              "field": "[concat('tags[', parameters('tagName'), ']')]",
              "exists": "false"
            },
            {
              "value": "[resourceGroup().tags[parameters('tagName')]]",
              "notEquals": ""
            }
          ]
        },
        "then": {
          "effect": "modify",
          "details": {
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "operations": [
              {
                "operation": "add",
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName')]]"
              }
            ]
          }
        }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
        "tagName": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[count.index]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[count.index]}"
        }
  }
PARAMETERS

}

resource "azurerm_policy_definition" "inheritTagFromRGOverwriteExisting" {
  count = length(var.mandatory_tag_keys)

  name                  = "bupa-inherit-TagFromRG_${var.mandatory_tag_keys[count.index]}_OverwriteExisting"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Inherit tag ${var.mandatory_tag_keys[count.index]} from the resource group & overwrite existing"
  description           = "Overwrites the specified mandatory tag ${var.mandatory_tag_keys[count.index]} and existing value using the RG's tag value. Applicable when any Resource containing the mandatory tag ${var.mandatory_tag_keys[count.index]} is created or updated. Ignores scenarios where tag values are the same for both Resource and RG, or when the RG's tag value is one of the parameters('tagValuesToIgnore'). Existing resources can be remediated by triggering a remediation task."
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
    {
    "category": "${var.policy_definition_category}",
    "version" : "1.0.0"
    }

METADATA


  policy_rule = <<POLICY_RULE
    {
        "if": {
          "allOf": [
            {
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "exists": "true"
            },
            {
                "value": "[resourceGroup().tags[parameters('tagName')]]",
                "notEquals": ""
            },
            {
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "notEquals": "[resourceGroup().tags[parameters('tagName')]]"
            },
            {
                "value": "[resourceGroup().tags[parameters('tagName')]]",
                "notIn": "[parameters('tagValuesToIgnore')]"
            }
          ]
        },
        "then": {
          "effect": "modify",
          "details": {
            "roleDefinitionIds": [
              "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
            ],
            "operations": [
              {
                "operation": "addOrReplace",
                "field": "[concat('tags[', parameters('tagName'), ']')]",
                "value": "[resourceGroup().tags[parameters('tagName')]]"
              }
            ]
          }
        }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
        "tagName": {
          "type": "String",
          "metadata": {
            "displayName": "Mandatory Tag ${var.mandatory_tag_keys[count.index]}",
            "description": "Name of the tag, such as '${var.mandatory_tag_keys[count.index]}'"
          },
          "defaultValue": "${var.mandatory_tag_keys[count.index]}"
        },
        "tagValuesToIgnore": {
          "type": "Array",
          "metadata": {
            "displayName": "Tag values to ignore for inheritance",
            "description": "A list of tag values to ignore when evaluating tag inheritance from the RG"
          },
          "defaultValue": [
              "tbc",
              "'tbc'",
              "TBC",
              "to_be_confirmed",
              "to be confirmed"
              ]
        }
  }
PARAMETERS

}
