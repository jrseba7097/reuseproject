resource "azurerm_policy_definition" "deny_publicip_spoke" {
  name                  = "bupa-deny-publicip-creation"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Bupa - Deny public IP in spoke"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Network"
  }

METADATA

  policy_rule = <<POLICY_RULE
{
	"if": {
    "field": "type",
    "in": [
      "Microsoft.Network/publicIPAddresses"
    ]
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}
