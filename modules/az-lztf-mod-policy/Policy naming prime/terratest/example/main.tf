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

  holder_management_group_name = var.holder_management_group_name
  scope_id                     = var.scope_id
  patterns = {
    "asg"          = "ASG-*"
    "connection"   = "CN-*"
    "er_circuit"   = "CIR-*"
    "kv"           = "KV-*"
    "ilb"          = "LBI-*"
    "elb"          = "LBE-*"
    "ilbbp"        = "LBIBEP-*"
    "elbbp"        = "LBEBEP-*"
    "logaw"        = "LOGAW-*"
    "nic"          = "NIC-*"
    "nsg"          = "NSG-*"
    "pip"          = "PIP-*"
    "rg"           = "RG-*"
    "rt"           = "RT-*"
    "route"        = "ROUTE-*"
    "rsv"          = "RSV-*"
    "stg_acc"      = "st*"
    "subnet"       = "SNET-*"
    "spoke_vm"     = "AZ*"
    "infra_hub_vm" = "eu????*"
    "vpn_vgw"      = "VPNGW-*"
    "er_vgw"       = "ERGW-*"
    "vnet_lgw"     = "LNG-*"
    "peering"      = "VNETPEER-*"
    "vnet"         = "VNET-*"
  }
}
