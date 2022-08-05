resource "azurerm_key_vault" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = var.sku_name

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  enable_rbac_authorization       = var.enable_rbac_authorization

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  network_acls {
    default_action             = var.default_action
    bypass                     = var.bypass
    ip_rules                   = var.allowed_ip_ranges
    virtual_network_subnet_ids = var.allowed_virtual_network_subnet_ids
  }

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
