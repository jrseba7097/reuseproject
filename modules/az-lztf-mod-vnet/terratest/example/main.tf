provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.64.0"
    }
  }
  required_version = ">= 1.0.0"
}

resource "azurerm_resource_group" "test" {
  name     = local.rg_name
  location = local.location
  tags     = local.tags
}

module "testing" {
  source = "../../"

  providers = {
    azurerm     = azurerm
    azurerm.hub = azurerm
  }

  vnet_name           = var.vnet.name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_spaces      = var.vnet.address_spaces
  dns_servers         = var.vnet.dns_servers
  subnets             = var.vnet.subnets
  peerings            = var.vnet.peerings

  ddos_protection_plan_id = var.vnet.ddos_protection_plan_id
}
