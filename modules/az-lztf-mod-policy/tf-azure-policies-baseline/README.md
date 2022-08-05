# README

Terraform module to generate baseline policies

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
| allowed\_locations | The list of locations that can be specified when deploying resources. | `list(string)` | n/a | yes |
| denied\_resources | The list of resource types that cannot be deployed. | `list(string)` | `[]` | no |
| exceptions | MG, subscription or RG ids to exclude from policies | `list(string)` | `[]` | no |
| holder\_management\_group\_name | Management group name to store policies | `string` | n/a | yes |
| log\_analytics\_id | The Log Analytics workspace of where the data should be exported to. If you do not already have a log analytics workspace, visit Log Analytics workspaces to create one. | `string` | n/a | yes |
| log\_analytics\_location | The location where the resource group and the export to Log Analytics workspace configuration are created. | `string` | n/a | yes |
| log\_analytics\_rg\_name | The resource group name where the export to Log Analytics workspace configuration is created. If you enter a name for a resource group that doesn't exist, it'll be created in the subscription. Note that each resource group can only have one export to Log Analytics workspace configured. | `string` | n/a | yes |
| required\_tags | The list of tags required when deploying resources. | `list(string)` | n/a | yes |
| scope\_id | Resource id to assign policies | `string` | n/a | yes |
| tag\_exception | Tag name and value in parent resource group to skip tag enforcement. Used to enable image creation. | `any` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
