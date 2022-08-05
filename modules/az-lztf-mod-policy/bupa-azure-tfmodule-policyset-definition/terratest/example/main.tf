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

  name                         = local.name
  display_name                 = local.display_name
  description                  = local.description
  holder_management_group_name = var.holder_management_group_name

  policies = [
    {
      policyID   = azurerm_policy_definition.test_definition.id
      parameters = <<VALUE
        {
          "allowedLocations": {"value": "[parameters('allowedLocations')]"}
        }
VALUE
    }
  ]
  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }
        }
    }
PARAMETERS
}
