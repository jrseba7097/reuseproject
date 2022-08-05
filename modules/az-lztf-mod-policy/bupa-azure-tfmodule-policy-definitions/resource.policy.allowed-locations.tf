resource "azurerm_policy_definition" "allowedlocations" {
  name                  = "bupa-allowed-locations"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Allowed Locations"
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
    "not": {
      "field": "location",
      "in": "[parameters('allowedLocations')]"
    }
  },
  "then": {
    "effect": "Deny"
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
