provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vault" {
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

 module "testing" {
  source = "../../"

  name                = var.name
  location            = azurerm_resource_group.vault.location
  resource_group_name = azurerm_resource_group.vault.name
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled
}