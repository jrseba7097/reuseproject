resource "azurerm_storage_account" "main" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_replication_type  = var.account_replication_type
  account_tier              = var.account_tier
  account_kind              = var.account_kind
  access_tier               = var.access_tier
  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version

  blob_properties {
    delete_retention_policy {
      days = var.delete_retention_policy_days
    }
  }

  network_rules {
    default_action             = var.default_action
    bypass                     = var.bypass
    ip_rules                   = var.allowed_ip_ranges
    virtual_network_subnet_ids = var.allowed_virtual_network_subnet_ids
  }

}
