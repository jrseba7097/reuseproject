terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = ">= 2.64.0"
      configuration_aliases = [azurerm.hub]
    }
  }
}
