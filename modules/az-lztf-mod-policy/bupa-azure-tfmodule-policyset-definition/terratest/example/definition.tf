resource "azurerm_policy_definition" "test_definition" {
  name                  = "bupa-allowed-locations-test"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa Allowed Locations - Test"
  management_group_name = var.holder_management_group_name

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS
}
