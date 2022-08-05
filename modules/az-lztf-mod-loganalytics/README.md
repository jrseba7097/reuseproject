# README

Terraform module to generate Azure Log Analytics and its solutions

## Usage Examples

```
module "log_analytics" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-log-analytics"

  workspace_name          = var.workspace_name
  location                = var.location
  resource_group_name     = azurerm_resource_group.rg.name
  linked_storage_accounts = [azurerm_storage_account.storage.id]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| azurerm | >= 2.68.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.68.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| linked\_storage\_accounts | List of storage accounts to link with the Log Analytics Workspace | `list` | `[]` | no |
| location | List of organisation wise approved region for workload deployment | `string` | n/a | yes |
| log\_retention\_days | Retention period for data within the Log Analytics Workspace | `number` | `365` | no |
| resource\_group\_name | Resource Group Name for  the Log Analytics Workspace | `string` | n/a | yes |
| solutions | List of Log Analytics Solutions to enable in the Log Analytics Workspace | `list` | `[]` | no |
| workspace\_name | Name of the Log Analytics Workspace | `string` | n/a | yes |
| workspace\_sku | Tier for the Log Analytics Workspace | `string` | `"PerGB2018"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The Log Analytics Workspace ID |
| location | The Workspace ID for the Log Analytics Workspace |
| primary\_shared\_key | The Primary shared key for the Log Analytics Workspace |
| resource\_group\_name | n/a |
| secondary\_shared\_key | The Secondary shared key for the Log Analytics Workspace |
| workspace\_id | The Workspace (or Customer) ID for the Log Analytics Workspace |
| workspace\_name | The Workspace Name for the Log Analytics Workspace |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
