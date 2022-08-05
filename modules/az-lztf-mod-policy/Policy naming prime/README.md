# README

Terraform module to generate Azure Naming Policy Initiative

## Usage Examples

```
module "naming_policies" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-policy-naming"

  providers = {
    azurerm = azurerm.governance
  }

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

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| azurerm | >= 2.64.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.64.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| exceptions | MG, subscription or RG ids to exclude from policies | `list(string)` | `[]` | no |
| holder\_management\_group\_name | Management group name to store policies | `string` | n/a | yes |
| patterns | Name patterns | `any` | n/a | yes |
| policyset\_definition\_category | The category to use for the PolicySet metadata | `string` | `"Custom"` | no |
| scope\_id | Resource id to assign policies | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_set\_assignment\_id | The policy set assignment id |
| policy\_set\_assignment\_name | The policy set assignment name |
| policy\_set\_definition\_id | The policy set definition id |
| policy\_set\_definition\_name | The policy set definition name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
