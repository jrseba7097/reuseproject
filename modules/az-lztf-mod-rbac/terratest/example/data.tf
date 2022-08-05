data "azurerm_subscription" "policy_testing" {
  subscription_id = var.policy_testing_subscription_id
}

data "azurerm_client_config" "current" {}