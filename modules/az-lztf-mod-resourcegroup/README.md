## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The full (Azure) location identifier for the Resource Group | `string` | n/a | yes |
| name | Resource Group name | `string` | n/a | yes |
| tags | Map of tags to assign the module components | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Recovery Services Vault. |
| name | The ID of the Recovery Services Vault. |
