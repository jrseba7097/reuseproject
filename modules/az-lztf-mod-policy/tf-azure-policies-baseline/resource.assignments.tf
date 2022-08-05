resource "azurerm_policy_assignment" "policy_set" {
  name                 = "bramblesBaselinePolicies"
  display_name         = "Brambles Baseline Policies"
  description          = "Brambles Baseline Policies enforce various controls over the resources to ensure resources stay compliant and in line with applicable standards and regulations."
  policy_definition_id = azurerm_policy_set_definition.main.id
  scope                = var.scope_id
  not_scopes           = var.exceptions
  location             = var.log_analytics_location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode(
    {
      "allowedLocations" : { "value" : var.allowed_locations },
      "deniedResources" : { "value" : var.denied_resources },
      "logAnalyticsRGName" : { "value" : var.log_analytics_rg_name },
      "logAnalyticsLocation" : { "value" : var.log_analytics_location },
      "logAnalyticsId" : { "value" : var.log_analytics_id }
  })
}

# Deploy-VM-Monitoring
resource "azurerm_policy_assignment" "enable_azure_monitor_for_vms" {
  name                 = "enableAzureMonitorForVMs"
  display_name         = "Enable Azure Monitor for VMs"
  description          = "Enable Azure Monitor for the virtual machines (VMs) in the specified scope (management group, subscription or resource group). Takes Log Analytics workspace as parameter."
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/55f3eceb-5573-4f18-9695-226972c6d74a"
  scope                = var.scope_id
  location             = var.log_analytics_location

  identity {
    type = "SystemAssigned"
  }

  parameters = jsonencode(
    {
      "logAnalytics_1" : { "value" : var.log_analytics_id }
  })
}
