# README

Terraform module to generate Azure Firewall Policy and rules

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
| fw\_application\_rules | List that manages Application Rule Collections within an Azure Firewall Policy | `list` | `[]` | no |
| fw\_nat\_rules | List that manages Nat Rule Collections within an Azure Firewall Policy | `list` | `[]` | no |
| fw\_network\_rules | List that manages Network Rule Collections within an Azure Firewall Policy | `list` | `[]` | no |
| fw\_threat\_intel\_mode | The firewall operation mode for threat intelligence-based filtering. Possible values are: Off, Alert and Deny. Defaults to Alert | `string` | `"Alert"` | no |
| location | The full (Azure) location identifier for the policy | `string` | n/a | yes |
| policy\_name | Name to deploy policy with | `string` | n/a | yes |
| resource\_group\_name | Resource Group to deploy the policy to | `string` | n/a | yes |
| tags | Map of tags to assign the module components | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| firewalls | A list of references to Azure Firewalls that this Firewall Policy is associated with |
| id | The ID of the Firewall Policy |
| rule\_collection\_groups | A list of references to Firewall Policy Rule Collection Groups that belongs to this Firewall Policy |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
