resource "azurerm_policy_definition" "policy_allow_vm_skus_definition" {
  name                  = "bupa-allowed-allowed-SKUs"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Allowed virtual machine SKUs"
  management_group_name = var.holder_management_group_name

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
          "field": "Microsoft.Compute/virtualMachines/sku.name",
          "in": "[parameters('listOfAllowedSKUs')]"
        }
      }
    ]
  },
  "then": {
    "effect": "Deny"
  }
}
POLICY_RULE

  parameters = <<PARAMETERS
{
  "listOfAllowedSKUs": {
  "type": "Array",
  "metadata": {
      "description": "The list of allowed VM SKUs for resources.",
      "displayName": "Allowed virtual machine SKUs",
      "strongType": "type"
    }
  }
}
PARAMETERS

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}
