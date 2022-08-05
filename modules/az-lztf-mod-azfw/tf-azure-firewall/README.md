# README

Terraform module to generate Azure Firewall

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| dns\_servers | A list of custom DNS servers' IP addresses | `list(any)` | `[]` | no |
| enable | Deploy Firewall true/false | `string` | n/a | yes |
| enable\_logs | Deploy diagnostic settings true/false | `string` | `"true"` | no |
| extra\_public\_ips | Names of extra public ips to associate to the firewall | `list(string)` | `[]` | no |
| firewall\_name | Name to deploy firewall with | `string` | n/a | yes |
| firewall\_pip\_name | Name to deploy firewall public ip with | `string` | n/a | yes |
| firewall\_policy\_id | The ID of the Firewall Policy applied to this Firewall | `string` | `""` | no |
| fw\_application\_rules | List that manages Application Rule Collections within an Azure Firewall Policy | `list(any)` | `[]` | no |
| fw\_nat\_rules | List that manages Nat Rule Collections within an Azure Firewall Policy | `list(any)` | `[]` | no |
| fw\_network\_fqdns\_rules | List that manages FQDNS Network Rule Collections within an Azure Firewall Policy | `list(any)` | `[]` | no |
| fw\_network\_rules | List that manages Network Rule Collections within an Azure Firewall Policy | `list(any)` | `[]` | no |
| fw\_threat\_intel\_mode | The firewall operation mode for threat intelligence-based filtering. Possible values are: Off, Alert and Deny. Defaults to Alert | `string` | `"Alert"` | no |
| location | The full (Azure) location identifier for the firewall | `string` | n/a | yes |
| log\_analytics\_workspace\_id | Log analytics workspace ID to use for the logs | `string` | n/a | yes |
| policy\_name | Name to deploy policy with | `string` | n/a | yes |
| proxy\_enabled | Whether to enable DNS proxy on Firewalls attached to this Firewall Policy? Defaults to false | `bool` | `false` | no |
| resource\_group\_name | Resource Group to deploy the firewall to | `string` | n/a | yes |
| retention\_days | The number of days for which this Retention Policy should apply | `number` | `365` | no |
| sku\_name | Sku name of the Firewall. Possible values are AZFW\_Hub and AZFW\_VNet. Changing this forces a new resource to be created | `string` | `"AZFW_VNet"` | no |
| sku\_tier | Sku tier of the Firewall. Possible values are Premium and Standard. Changing this forces a new resource to be created | `string` | `"Standard"` | no |
| storage\_account\_id | Storage account id to log the events to | `string` | n/a | yes |
| subnet\_id | Subnet Id to deploy firewall in | `string` | n/a | yes |
| tags | Map of tags to assign the module components | `map(any)` | `{}` | no |
| zones | Specifies the availability zones in which the Azure Firewall should be created. Changing this forces a new resource to be created | `list(any)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Firewall resource id |
| private\_ip\_address | The private IP address value that was allocated for the Firewall |
| public\_ip\_address | The public IP address value that was allocated for the Firewall |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
