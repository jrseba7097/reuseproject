resource "azurerm_policy_set_definition" "initiative" {
  name                  = "bupaNaming"
  policy_type           = "Custom"
  display_name          = "Bupa Naming policies"
  management_group_name = var.holder_management_group_name

  metadata = <<METADATA
    {
      "category": "${var.policyset_definition_category}"
    }
METADATA

  parameters = <<PARAMETERS
 {
  "asgNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Application Security Group name pattern"
    },
    "defaultValue": "ASG-*"
  },
  "connectionNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Connection name pattern"
    },
    "defaultValue": "CN-*"
  },
  "erCircuitNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "ER Circuit name pattern"
    },
    "defaultValue": "CIR-*"
  },
  "kvNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "KeyVault name pattern"
    },
    "defaultValue": "KV-*"
  },
  "internalLbNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Internal Load Balancer name pattern"
    },
    "defaultValue": "LBI-*"
  },
  "externalLbNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "External Load Balancer name pattern"
    },
    "defaultValue": "LBE-*"
  },
  "internalLbBackendNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Internal Load Balancer name pattern"
    },
    "defaultValue": "LBIBEP-*"
  },
  "externalLbBackendNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "External Load Balancer name pattern"
    },
    "defaultValue": "LBEBEP-*"
  },
  "logawNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Log Analytics workspace name pattern"
    },
    "defaultValue": "LOGAW-*"
  },
  "nicNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Network interface name pattern"
    },
    "defaultValue": "NIC-*"
  },
  "nsgNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "NSG name pattern"
    },
    "defaultValue": "NSG-*"
  },
  "pipNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "PIP name pattern"
    },
    "defaultValue": "PIP-*"
  },
  "rgNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Resource group name pattern"
    },
    "defaultValue": "RG-*"
  },
  "routeTableNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Route table name pattern"
    },
    "defaultValue": "RT-*"
  },
  "routeNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Route name pattern"
    },
    "defaultValue": "ROUTE-*"
  },
  "rsvNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Recovery services vault name pattern"
    },
    "defaultValue": "RSV-*"
  },
  "stgAccNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Stg acc name pattern"
    },
    "defaultValue": "st*"
  },
  "subnetNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "VNET Subnet name pattern"
    },
    "defaultValue": "SNET-*"
  },
  "spokeVmPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Spoke VM name pattern"
    },
    "defaultValue": "AZ*"
  },
  "infraHubVmPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Infra Hub VM name pattern"
    },
    "defaultValue": "eu????*"
  },
  "vpnVgwPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Infra Hub VM name pattern"
    },
    "defaultValue": "VPNGW-*"
  },
  "erVgwPattern": {
    "type": "String",
    "metadata": {
      "displayName": "Infra Hub VM name pattern"
    },
    "defaultValue": "ERGW-*"
  },
  "vnetLgwNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Vnet LGW name pattern"
    },
    "defaultValue": "LNG-*"
  },
  "peeringNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "VNET Peering name pattern"
    },
    "defaultValue": "VNETPEER-*"
  },
  "vnetNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Vnet name pattern"
    },
    "defaultValue": "VNET-*"
  }
}
PARAMETERS

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.asg_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('asgNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.connection_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('connectionNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.er_circuit_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('erCircuitNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.kv_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('kvNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.lb_naming.id
    parameter_values     = <<VALUE
{
  "internalNamePattern": { "value": "[parameters('internalLbNamePattern')]"},
  "externalNamePattern": { "value": "[parameters('externalLbNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.lb_pool_naming.id
    parameter_values     = <<VALUE
{
  "internalNamePattern": { "value": "[parameters('internalLbBackendNamePattern')]"},
  "externalNamePattern": { "value": "[parameters('externalLbBackendNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.logaw_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('logawNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.nic_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('nicNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.nsg_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('nsgNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.pip_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('pipNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.rg_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('rgNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.route_table_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('routeTableNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.route_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('routeNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.rsv_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('rsvNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.stg_acc_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('stgAccNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.subnet_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('subnetNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.vm_naming.id
    parameter_values     = <<VALUE
{
  "spokePattern": { "value": "[parameters('spokeVmPattern')]"},
  "infraHubPattern": { "value": "[parameters('infraHubVmPattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.vgw_naming.id
    parameter_values     = <<VALUE
{
  "vpnNamePattern": { "value": "[parameters('vpnVgwPattern')]"},
  "erNamePattern": { "value": "[parameters('erVgwPattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.vnet_lgw_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('vnetLgwNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.peering_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('peeringNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.vnet_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('vnetNamePattern')]"}
}
VALUE
  }
}
