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

data "azurerm_client_config" "current" {}

module "testing" {
  source = "../../"
  name                 = var.name
  scope                = var.scope
  policy_definition_id = var.policy_definition_id
  description          = var.description
  display_name         = var.display_name
}
