resource "azurerm_policy_definition" "require_storage_https_only" {
  name                  = "bupa-require-storage-https-only"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Require storage account HTTPS only"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
  {
    "category": "Storage"
  }
METADATA

  policy_rule = <<POLICY_RULE
{
    "if": {
        "allOf": [
            {
                "field": "type",
                "equals": "Microsoft.Storage/storageAccounts"
            },
            {
                "anyOf": [
                    {
                        "allOf": [
                            {
                                "value": "[requestContext().apiVersion]",
                                "less": "2019-04-01"
                            },
                            {
                                "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
                                "exists": "false"
                            }
                        ]
                    },
                    {
                        "field": "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly",
                        "equals": "false"
                    }
                ]
            }
        ]
    },
    "then": {
        "effect": "deny"
    }
}
POLICY_RULE
}
