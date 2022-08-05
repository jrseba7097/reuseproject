resource "azurerm_public_ip" "azure_firewall_pip" {
  count = lower(var.enable) == "true" ? 1 : 0

  name                = var.firewall_pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_public_ip" "azure_firewall_pip_extra" {
  count = length(var.extra_public_ips)

  name                = var.extra_public_ips[count.index]
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_firewall" "main" {
  count = lower(var.enable) == "true" ? 1 : 0

  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = var.zones
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.main.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = azurerm_public_ip.azure_firewall_pip[0].id
  }

  dynamic "ip_configuration" {
    for_each = var.extra_public_ips

    content {
      name                 = "AzureFirewallIpConfiguration${ip_configuration.key + 1}"
      public_ip_address_id = azurerm_public_ip.azure_firewall_pip_extra[ip_configuration.key].id
    }
  }

  tags = var.tags
}
