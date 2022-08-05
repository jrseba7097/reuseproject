# README

Terraform module to generate Azure Route table with routes and associate it to subnets

## Usage Examples

```
module "udr" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-udr"

  name                = local.udr_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  routes              = var.udr_routes
  subnet_ids = [
    module.vnet.subnet_ids[0],
  ]
}

variable "udr_routes" {
  description = "Parameters to configure routes in UDR table"
  type        = list(object({
    name                = string
    address_prefix      = string
    next_hop_type       = string
    next_hop_in_ip_address = string
  }))
}

udr_routes = [
  {
    name                   = "ROUTE-Default"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "192.168.0.0"
  },
]

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
| disable\_bgp\_route\_propagation | Boolean flag which controls propagation of routes learned by BGP on that route table. True means disable | `string` | `"true"` | no |
| location | The full (Azure) location identifier for the route table | `string` | n/a | yes |
| name | The name of the route table. Changing this forces a new resource to be created | `string` | n/a | yes |
| resource\_group\_name | Resource Group to deploy the route table to | `string` | n/a | yes |
| routes | List of objects representing routes | <pre>list(<br>    object({<br>      name                   = string<br>      address_prefix         = string<br>      next_hop_type          = string<br>      next_hop_in_ip_address = string<br>    })<br>  )</pre> | n/a | yes |
| subnet\_ids | List of Subnet ids which should be associated with the Route Table | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The Route Table ID |
| name | UDR table name |
| routes | UD routes |
| subnets | The collection of Subnets associated with this route table |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
