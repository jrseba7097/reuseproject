resource "azurerm_policy_definition" "require_rg_tag_match" {
  name                  = "bupa-require-rg-tag-match"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Require tag match on resource groups"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Tags"
  }
METADATA

  policy_rule = <<POLICY_RULE
{
  "if": {
    "allOf": [
      {
        "equals": "Microsoft.Resources/subscriptions/resourceGroups",
        "field": "type"
      },
      {
        "not": {
          "anyOf": [
            {
              "allOf": [
                {
                  "field": "[concat('tags[', parameters('tagName'), ']')]",
                  "exists": true
                },
                {
                  "field": "[concat('tags[', parameters('tagName'), ']')]",
                  "in": "[parameters('tagValues')]"
                }
              ]
            },
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
    "effect": "deny"
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "tagName": {
    "type": "String",
    "metadata": {
      "displayName": "Tag Name",
      "description": "Name of the tag, such as 'ENV'"
    }
  },
  "tagValues": {
    "type": "Array",
    "metadata": {
      "displayName": "Tag Values",
      "description": "List of values allowed for the tag"
    }
  }
}
PARAMETERS
}
