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

resource "azurerm_virtual_network" "test" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.test.name
  address_space       = [var.address_prefix]
}

resource "azurerm_subnet" "test" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.test.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = [var.address_prefix]
}

module "testing" {
  source = "../../"

  name                  = var.name
  location              = azurerm_resource_group.test.location
  resource_group_name   = azurerm_resource_group.test.name
  ip_configuration_name = var.ip_configuration_name
  public_ip_name        = var.public_ip_name
  subnet_id             = azurerm_subnet.test.id
}
