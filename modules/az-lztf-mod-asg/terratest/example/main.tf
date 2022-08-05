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

  name                = local.asg_name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
}
