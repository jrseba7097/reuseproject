resource "azurerm_policy_definition" "audit_storage_public" {
  name                  = "bupa-audit-storage-public"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Bupa - Audit Storage account public facing"
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
        "not": {
          "field": "Microsoft.Storage/storageAccounts/allowBlobPublicAccess",
          "equals": "false"
        }
      }
    ]
  },
  "then": {
    "effect": "audit"
  }
}
POLICY_RULE
}
