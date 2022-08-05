# README

Terraform module to generate Azure VNET and subnets

## Usage Examples

```
module "vnet" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-vnet"

  providers = {
    azurerm     = azurerm
    azurerm.hub = azurerm.hub
  }

  vnet_name           = var.vnet.name
  location            = azurerm_resource_group.test.location
  resource_group_name = azurerm_resource_group.test.name
  address_spaces      = var.vnet.address_spaces
  dns_servers         = var.vnet.dns_servers
  subnets             = var.vnet.subnets
  peerings            = var.vnet.peerings

  ddos_protection_plan_id = var.vnet.ddos_protection_plan_id
}

variable "vnet" {
  description = "Parameters to configure VNET"
  type        = object({
    name                    = string
    address_spaces          = list(string)
    dns_servers             = list(string)
    ddos_protection_plan_id = string
    subnets                 = list(object({
      name              = string
      address_prefixes  = list(string)
      service_endpoints = list(string)
    }))
    peerings = list(object({
      hub_resource_group_name           = string
      hub_vnet_name                     = string
      hub_vnet_id                       = string
      name_to_spoke                     = string
      allow_vnet_access_hub_spoke       = bool
      allow_forwarded_traffic_hub_spoke = bool
      allow_gateway_transit_hub_spoke   = bool
      use_remote_gateways_hub_spoke     = bool
      name_to_hub                       = string
      allow_vnet_access_spoke_hub       = bool
      allow_forwarded_traffic_spoke_hub = bool
      allow_gateway_transit_spoke_hub   = bool
      use_remote_gateways_spoke_hub     = bool
    }))
  })
}

vnet = {
  name                    = "VNET-cose-eun-SemiTrustTestSpoke"
  address_spaces          = ["192.168.1.0/24", ]
  dns_servers             = []
  ddos_protection_plan_id = ""
  subnets = [
    {
      name              = "SNET-cose-eun-SemiTrustTestSpoke-Test"
      address_prefixes  = ["192.168.1.0/24", ]
      service_endpoints = []
    },
  ]
  peerings = [
    {
      hub_resource_group_name           = "RG-itss-eun-HubCoreNetwork"
      hub_vnet_name                     = "VNET-itss-eun-SemiTrustHub"
      hub_vnet_id                       = "/subscriptions/30372651-4e48-4bfe-8d90-3c632da013b6/resourceGroups/RG-itss-eun-HubCoreNetwork/providers/Microsoft.Network/virtualNetworks/VNET-itss-eun-SemiTrustHub"
      name_to_spoke                     = "VNETPEER-eun-SemiTrustHub-to-eun-cose-SemiTrustTestSpoke"
      allow_vnet_access_hub_spoke       = true
      allow_forwarded_traffic_hub_spoke = true
      allow_gateway_transit_hub_spoke   = false
      use_remote_gateways_hub_spoke     = false
      name_to_hub                       = "VNETPEER-eun-cose-SemiTrustTestSpoke-to-eun-SemiTrustHub"
      allow_vnet_access_spoke_hub       = true
      allow_forwarded_traffic_spoke_hub = true
      allow_gateway_transit_spoke_hub   = false
      use_remote_gateways_spoke_hub     = false
    },
  ]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| azurerm.hub | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_spaces | List of the full VNet CIDR ranges for VNet | `list(any)` | n/a | yes |
| ddos\_protection\_plan\_id | Ddos protection plan id to be used in the VNET if enabled | `string` | n/a | yes |
| dns\_servers | The IP address of the DNS server to be given on the primary subnet via DHCP | `list(any)` | `[]` | no |
| location | The full (Azure) location identifier for vnet | `string` | n/a | yes |
| resource\_group\_name | Resource Group where the is vnet is deployed to | `string` | n/a | yes |
| peerings | List of objects to configure peerings in Vnet | `list(any)` | `[]` | no |
| subnets | List of objects to configure subnets in Vnet | `list(any)` | `[]` | no |
| vnet\_name | Name to deploy vnet with | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| address\_space | Vnet address space |
| subnet\_ids | Subnet Ids in the Vnet |
| vnet\_id | Vnet id |
| vnet\_name | Vnet name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
