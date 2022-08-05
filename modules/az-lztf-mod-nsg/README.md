# README

Terraform module to generate Azure Network Security Group, its rules and flow log

## Usage Examples

```
module "nsg" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-nsg"

  name                = local.nsg_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
  rules               = var.nsg_rules
  subnet_ids = [
    module.vnet.subnet_ids[0],
  ]
}

variable "nsg_rules" {
  description = "List of NSG rules"
  type        = list(object({
    name                        = string
    priority                    = number
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    source_port_ranges          = list(string)
    destination_port_range      = string
    destination_port_ranges     = list(string)
    source_address_prefix       = string
    source_address_prefixes     = list(string)
    destination_address_prefix  = string
    destination_address_prefixes = list(string)
  }))
  default     = []
}

nsg_rules = [
  {
      name                        = "HTTPS-to-Test"
      priority                    = 100
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "*"
      source_port_range           = "*"
      destination_port_range      = "443"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
      source_port_ranges           = null
      destination_port_ranges      = null
      source_address_prefixes      = null
      destination_address_prefixes = null
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
| enable\_flow\_log | Flag to enable Flog logs on NSG | `bool` | `false` | no |
| flow\_log\_version | The version (revision) of the flow log. Possible values are 1 and 2 | `number` | `2` | no |
| location | The full (Azure) location identifier for the NSG | `string` | n/a | yes |
| name | Specifies the name of the network security group. Changing this forces a new resource to be created | `string` | n/a | yes |
| network\_watcher\_name | The name of the Network Watcher. Changing this forces a new flow log resource to be created | `string` | `""` | no |
| network\_watcher\_resource\_group\_name | The name of the resource group in which the Network Watcher was deployed. Changing this forces a new flow log resource to be created | `string` | `""` | no |
| resource\_group\_name | Resource Group to deploy the NSG to | `string` | n/a | yes |
| retention\_policy\_days | The number of days to retain flow log records | `number` | `365` | no |
| retention\_policy\_enabled | Boolean flag to enable/disable retention | `bool` | `true` | no |
| rules | List of objects representing security rules | `list(any)` | n/a | yes |
| storage\_account\_id | The ID of the Storage Account where flow logs are stored | `string` | `""` | no |
| storage\_account\_logs\_enabled | Should Network Flow Logging be Enabled? | `bool` | `true` | no |
| subnet\_ids | List of Subnet ids which should be associated with the NSG | `list(any)` | n/a | yes |
| traffic\_analytics\_enabled | Boolean flag to enable/disable traffic analytics | `bool` | `false` | no |
| traffic\_analytics\_interval\_in\_minutes | How frequently service should do flow analytics in minutes | `number` | `60` | no |
| workspace\_id | The resource guid of the attached workspace | `string` | `""` | no |
| workspace\_region | The location of the attached workspace | `string` | `""` | no |
| workspace\_resource\_id | The resource ID of the attached workspace | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Network Security Group |
| name | The name of the Network Security Group |
| rules | The rules of the Network Security Group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
