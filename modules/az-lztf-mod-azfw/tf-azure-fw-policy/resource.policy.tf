resource "azurerm_firewall_policy" "main" {
  name                     = var.policy_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  threat_intelligence_mode = var.fw_threat_intel_mode

  tags = var.tags
}
