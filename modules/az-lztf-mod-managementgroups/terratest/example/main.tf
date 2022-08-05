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

module "testing" {
  source = "../../"

  management_groups          = var.management_groups
  parent_management_group_id = var.parent_management_group_id
}
