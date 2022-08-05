provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    "Billing"    = "INSYS-77662"
    "IT Service" = "ITSS Connectivity and Networks"
    "Owner ID"   = ""
    "Project"    = ""
    "ENV"        = "Build"
  }
}

resource "azurerm_storage_account" "test" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.test.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

module "testing" {
  source = "../../"

  name                     = var.name
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location
  tenant_id                = data.azurerm_client_config.current.tenant_id
  bypass                   = var.bypass
  purge_protection_enabled = var.purge_protection_enabled
  storage_account_id       = azurerm_storage_account.test.id
  diag_name                = var.diag_name
}
