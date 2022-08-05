resource "azurerm_policy_definition" "audit_storage_encryption" {
  name                  = "bupa-audit-storage-encryption"
  policy_type           = "Custom"
  mode                  = "Indexed"
  display_name          = "Bupa - Audit Storage account custom-managed key for encryption"
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
          "field": "Microsoft.Storage/storageAccounts/encryption.keySource",
          "equals": "Microsoft.Keyvault"
        }
      }
    ]
  },
  "then": {
    "effect": "Audit"
  }
}
POLICY_RULE
}
