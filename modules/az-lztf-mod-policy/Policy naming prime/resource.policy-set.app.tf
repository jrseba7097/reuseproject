resource "azurerm_policy_set_definition" "app" {
  name                  = "bramblesNamingApp"
  policy_type           = "Custom"
  display_name          = "Brambles Naming policies - App"
  management_group_name = var.holder_management_group_name

  parameters = <<PARAMETERS
 {
  "rgNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Resource group name pattern"
    },
    "defaultValue": "rg-*-*-*-###"
  },
  "vnetNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Vnet name pattern"
    },
    "defaultValue": "vnet-*-*-*"
  },
  "vnetVgwNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Vnet VGW name pattern"
    },
    "defaultValue": "vnet-vgw-*-*-###"
  },
  "vnetLgwNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Vnet LGW name pattern"
    },
    "defaultValue": "vnet-lgw-*-*-###"
  },
  "connectionNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Connection name pattern"
    },
    "defaultValue": "er-cn-vnet-*"
  },
  "erCircuitNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Connection name pattern"
    },
    "defaultValue": "er-*-*-###"
  },
  "peeringNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "VNET Peering name pattern"
    },
    "defaultValue": "cn-*"
  },
  "subnetNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "VNET Subnet name pattern"
    },
    "defaultValue": "snet-*"
  },
  "nsgNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "NSG name pattern"
    },
    "defaultValue": "nsg-*-###"
  },
  "pipNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "PIP name pattern"
    },
    "defaultValue": "pip-*-###"
  },
  "stgAccNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Stg acc name pattern"
    },
    "defaultValue": "st*###"
  },
  "rehostVmNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Rehost VM name pattern"
    },
    "defaultValue": "???????###"
  },
  "replatVmNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Replaform VM name pattern"
    },
    "defaultValue": "??####??##"
  },
  "applianceVmNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Appliance VM name pattern"
    },
    "defaultValue": "??####??###"
  },
  "dcVmNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "DC VM name pattern"
    },
    "defaultValue": "?????DC##"
  },
  "lbNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Load Balancer name pattern"
    },
    "defaultValue": "lb-*-*-###"
  },
  "nicNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Network interface name pattern"
    },
    "defaultValue": "nic-##-*"
  },
  "appNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "App service name pattern"
    },
    "defaultValue": "azapp-*-*-###"
  },
  "funcNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "App service name pattern"
    },
    "defaultValue": "azfun-*-*-###"
  },
  "csNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "App service name pattern"
    },
    "defaultValue": "azcs-*-*-###"
  },
  "sqlDbNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "SQL DB name pattern"
    },
    "defaultValue": "sqldb-*-*-###"
  },
  "docDbNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Doc DB name pattern"
    },
    "defaultValue": "cosdb-*-*-###"
  },
  "redisNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Redis name pattern"
    },
    "defaultValue": "redis-*-*-###"
  },
  "mysqlNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "MySQL name pattern"
    },
    "defaultValue": "mysql-*-*-###"
  },
  "sqlDwNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "SQL DataWarehouse name pattern"
    },
    "defaultValue": "sqldw-*-*-###"
  },
  "sqlStrNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "SQL Stretch DB name pattern"
    },
    "defaultValue": "sqlstrdb-*-*-###"
  },
  "legacyVmNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "Legacy VM name pattern"
    },
    "defaultValue": "???????##"
  },
  "wvdVmNamePattern": {
    "type": "String",
    "metadata": {
      "displayName": "WVD VM name pattern"
    },
    "defaultValue": "??MSAWVD????###"
  }
}
PARAMETERS

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.rg_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('rgNamePattern')]"}
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

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.vnet_vgw_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('vnetVgwNamePattern')]"}
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
    policy_definition_id = azurerm_policy_definition.peering_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('peeringNamePattern')]"}
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
    policy_definition_id = azurerm_policy_definition.stg_acc_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('stgAccNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.vm_naming_app.id
    parameter_values     = <<VALUE
{
  "rehostPattern": { "value": "[parameters('rehostVmNamePattern')]"},
  "replatPattern": { "value": "[parameters('replatVmNamePattern')]"},
  "appliancePattern": { "value": "[parameters('applianceVmNamePattern')]"},
  "dcPattern": { "value": "[parameters('dcVmNamePattern')]"},
  "legacyPattern": { "value": "[parameters('legacyVmNamePattern')]"},
  "wvdPattern": { "value": "[parameters('wvdVmNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.lb_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('lbNamePattern')]"}
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
    policy_definition_id = azurerm_policy_definition.app_naming.id
    parameter_values     = <<VALUE
{
  "appPattern": { "value": "[parameters('appNamePattern')]"},
  "funcPattern": { "value": "[parameters('funcNamePattern')]"},
  "csPattern": { "value": "[parameters('csNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.sql_naming.id
    parameter_values     = <<VALUE
{
  "sqlPattern": { "value": "[parameters('sqlDbNamePattern')]"},
  "sqlStrPattern": { "value": "[parameters('sqlStrNamePattern')]"},
  "sqlDwPattern": { "value": "[parameters('sqlDwNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.doc_db_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('docDbNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.redis_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('redisNamePattern')]"}
}
VALUE
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.mysql_naming.id
    parameter_values     = <<VALUE
{
  "namePattern": { "value": "[parameters('mysqlNamePattern')]"}
}
VALUE
  }
}
