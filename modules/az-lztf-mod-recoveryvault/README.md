## Usage Examples

```
module "recovery_vault" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-recovery_vault"

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled
}

variable "policies" {
  type = list(
    object({
      name                           = string
      timezone                       = string
      instant_restore_retention_days = number
      frequency                      = string
      time                           = string
      retention_daily_count          = number
      retention_weekly_count         = number
      retention_weekly_days          = list(string)
      retention_monthly_count        = number
      retention_monthly_days         = list(string)
      retention_monthly_weeks        = list(string)
      retention_yearly_count         = number
      retention_yearly_days          = list(string)
      retention_yearly_weeks         = list(string)
      retention_yearly_months        = list(string)
    })
}
policies = [
  {
    name                         = "Backup-policy-test"
      timezone                       = "UTC"
      instant_restore_retention_days = 30
      frequency                      = null
      time                           = null
      retention_daily_count          = 30
      retention_weekly_count         = 8
      retention_weekly_days          = null
      retention_monthly_count        = 12
      retention_monthly_days         = null
      retention_monthly_weeks        = null
      retention_yearly_count         = 3
      retention_yearly_days          = null
      retention_yearly_weeks         = null
      retention_yearly_months        = null
  },
]


```
# README

Terraform module to generate Azure Recovery Vault and backup policies
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
| location | List of organisation wise approved region for workload deployment | `string` | n/a | yes |
| name | Name of the Recovery Vault | `string` | n/a | yes |
| policies | List of Backup policies to use in the Recovery Vault | <pre>list(<br>    object({<br>      name                           = string<br>      timezone                       = string<br>      instant_restore_retention_days = number<br>      frequency                      = string<br>      time                           = string<br>      retention_daily_count          = number<br>      retention_weekly_count         = number<br>      retention_weekly_days          = list(string)<br>      retention_monthly_count        = number<br>      retention_monthly_days         = list(string)<br>      retention_monthly_weeks        = list(string)<br>      retention_yearly_count         = number<br>      retention_yearly_days          = list(string)<br>      retention_yearly_weeks         = list(string)<br>      retention_yearly_months        = list(string)<br>    })<br>  )</pre> | `[]` | no |
| resource\_group\_name | Resource Group Name for the Recovery Vault | `string` | n/a | yes |
| sku | Sets the vault's SKU. Possible values include: Standard, RS0 | `string` | `"Standard"` | no |
| soft\_delete\_enabled | Is soft delete enable for this Vault? Defaults to true | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Recovery Services Vault |
| name | The name of the Recovery Services Vault |
| policy\_ids | The ID of the VM Backup Policies |
| policy\_names | The name of the VM Backup Policies |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
