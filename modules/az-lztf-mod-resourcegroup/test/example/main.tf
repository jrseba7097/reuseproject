provider azurerm {
  version = "=2.42.0"
  subscription_id = "7be66cc0-c327-4636-8d09-08c4dddf12c1"
  features {}
}

module testing {
  source = "../../"

  name     = var.name
  location = var.location
  tags     = var.tags
}