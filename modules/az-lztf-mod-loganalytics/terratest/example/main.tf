provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_name
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = var.tier
  account_replication_type = var.replication
}

data "azurerm_client_config" "current" {}


module "testing" {
  source = "../../"

  workspace_name          = local.wks_name
  location                = local.location
  resource_group_name     = azurerm_resource_group.rg.name
  linked_storage_accounts = [azurerm_storage_account.storage.id]
}
