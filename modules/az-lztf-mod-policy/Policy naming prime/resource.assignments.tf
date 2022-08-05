resource "azurerm_policy_assignment" "initiative" {
  name                 = "bupaNaming"
  display_name         = "Bupa Naming Policies"
  description          = "This initiative includes naming policies to enforce Bupa Azure naming convention"
  policy_definition_id = azurerm_policy_set_definition.initiative.id
  scope                = var.scope_id

  not_scopes = var.exceptions

  parameters = jsonencode(
    {
      "asgNamePattern" : { "value" : var.patterns.asg },
      "connectionNamePattern" : { "value" : var.patterns.connection },
      "erCircuitNamePattern" : { "value" : var.patterns.er_circuit },
      "kvNamePattern" : { "value" : var.patterns.kv },
      "internalLbNamePattern" : { "value" : var.patterns.ilb },
      "externalLbNamePattern" : { "value" : var.patterns.elb },
      "internalLbBackendNamePattern" : { "value" : var.patterns.ilbbp },
      "externalLbBackendNamePattern" : { "value" : var.patterns.elbbp },
      "logawNamePattern" : { "value" : var.patterns.logaw },
      "nicNamePattern" : { "value" : var.patterns.nic },
      "nsgNamePattern" : { "value" : var.patterns.nsg },
      "pipNamePattern" : { "value" : var.patterns.pip },
      "rgNamePattern" : { "value" : var.patterns.rg },
      "routeTableNamePattern" : { "value" : var.patterns.rt },
      "routeNamePattern" : { "value" : var.patterns.route },
      "rsvNamePattern" : { "value" : var.patterns.rsv },
      "stgAccNamePattern" : { "value" : var.patterns.stg_acc },
      "subnetNamePattern" : { "value" : var.patterns.subnet },
      "spokeVmPattern" : { "value" : var.patterns.spoke_vm },
      "infraHubVmPattern" : { "value" : var.patterns.infra_hub_vm },
      "vpnVgwPattern" : { "value" : var.patterns.vpn_vgw },
      "erVgwPattern" : { "value" : var.patterns.er_vgw },
      "vnetLgwNamePattern" : { "value" : var.patterns.vnet_lgw },
      "peeringNamePattern" : { "value" : var.patterns.peering },
      "vnetNamePattern" : { "value" : var.patterns.vnet }
  })
}
