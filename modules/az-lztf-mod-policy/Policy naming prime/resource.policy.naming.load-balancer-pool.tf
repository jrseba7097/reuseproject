resource "azurerm_policy_definition" "lb_pool_naming" {
  name                  = "lbPoolNaming"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Naming policy definition for load balancer backend pools"
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
                "equals": "Microsoft.Network/loadBalancers/backendAddressPools"
            },
            {
                "not": {
                    "anyOf": [
                        {
                            "value": "[equals(first(split(parameters('internalNamePattern'), '-')), first(split(field('name'), '-')))]",
                            "equals": true
                        },
                        {
                            "value": "[equals(first(split(parameters('externalNamePattern'), '-')), first(split(field('name'), '-')))]",
                            "equals": true
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
  "internalNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Internal Pattern",
      "description": "Internal Pattern to check for naming convention"
    }
  },
  "externalNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "External Pattern",
      "description": "External Pattern to check for naming convention"
    }
  }
}
PARAMETERS
}
