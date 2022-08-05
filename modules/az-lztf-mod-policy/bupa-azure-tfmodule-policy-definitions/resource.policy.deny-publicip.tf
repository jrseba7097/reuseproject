resource "azurerm_policy_definition" "deny_publicips_on_nics" {
  name                  = "bupa-deny-publicips-on-nics"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Bupa Deny Public IP on NICS"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Network"
  }

METADATA

  policy_rule = <<POLICY_RULE
{
	"if": {
		"allOf": [
			{
				"field": "type",
				"equals": "Microsoft.Network/networkInterfaces"
			},
			{
				"field": "Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIpAddress.id",
				"exists": true
			}
		]
	},
	"then": {
		"effect": "deny"
	}
}
POLICY_RULE
}
