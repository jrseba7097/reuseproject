resource "azurerm_policy_definition" "require_storage_file_encryption" {
  name                  = "bupa-require-storage-file-encryption"
  policy_type           = "Custom"
  mode                  = "All"
  display_name          = "Bupa - Require storage account file encryption"
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
                "field": "Microsoft.Storage/storageAccounts/enableFileEncryption",
                "equals": "false"
            }
        ]
    },
    "then": {
        "effect": "deny"
    }
}
POLICY_RULE
}
