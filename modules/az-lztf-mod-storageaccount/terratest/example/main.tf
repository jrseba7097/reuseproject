provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = local.rg_name
  location = local.location
  tags = local.tags
}


data "azurerm_client_config" "current" {}


module "testing" {
  source = "../../"

  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.test.name
  location                 = local.location
  bypass                   = var.bypass
  account_replication_type = var.account_replication_type
}