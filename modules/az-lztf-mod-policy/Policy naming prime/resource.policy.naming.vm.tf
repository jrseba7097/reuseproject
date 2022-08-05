resource "azurerm_policy_definition" "vm_naming" {
  name                  = "vmNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for VMs"
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
                "equals": "Microsoft.Compute/virtualMachines"
            },
            {
                "not": {
                    "anyOf": [
                        {
                            "value": "[substring(field('name'), 0, 2)]",
                            "match": "[substring(parameters('spokePattern'), 0, 2)]"
                        },
                        {
                            "value": "[substring(field('name'), 0, 6)]",
                            "match": "[substring(parameters('infraHubPattern'), 0, 6)]"
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
  "spokePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Spoke Pattern",
      "description": "Spoke Pattern to check for naming convention"
    }
  },
  "infraHubPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Infra Hub Pattern",
      "description": "Infra Hub Pattern to check for naming convention"
    }
  }
}
PARAMETERS
}
