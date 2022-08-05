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

  holder_management_group_name = var.holder_management_group_name
  mandatory_tag_keys           = var.mandatory_tag_keys
}
