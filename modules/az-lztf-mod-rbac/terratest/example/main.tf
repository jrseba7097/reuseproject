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

  custom_role_definitions = [
    {
      name              = "Custom role definition - test"
      description       = "Test role definition creation"
      scope             = data.azurerm_subscription.policy_testing.id
      assignable_scopes = [data.azurerm_subscription.policy_testing.id]
      permissions = {
        actions          = ["*/read"]
        not_actions      = []
        data_actions     = []
        not_data_actions = []
      }
    }
  ]

  role_assignments = [
    {
      definition_scope     = data.azurerm_subscription.policy_testing.id
      role_definition_name = "Reader"
      role_definition_id   = null
      assignment_scope     = data.azurerm_subscription.policy_testing.id
      principal_id         = data.azurerm_client_config.current.object_id
    },
  ]
}
