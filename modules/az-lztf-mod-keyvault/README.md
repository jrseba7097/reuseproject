# README

Terraform module to generate Azure KeyVault, access policies and secrets

## Usage Examples

```
module "key_vault" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-keyvault"

  providers = {
    azurerm = azurerm.spoke-semitrust
  }

  name                = local.key_vault_name
  resource_group_name = azurerm_resource_group.semitrust.name
  location            = azurerm_resource_group.semitrust.location
  tenant_id           = data.azurerm_client_config.current.tenant_id

  enable_logs                = "true"
  storage_account_id         = module.storage_account.id
  log_analytics_workspace_id = module.log_analytics.id

  enabled_for_deployment      = true
  enabled_for_disk_encryption = true

  bypass = "AzureServices"
  allowed_virtual_network_subnet_ids = concat(
    module.primary_semi_trust_vnet.subnet_ids,
    [],
  )
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
| allowed\_ip\_ranges | One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault | `list(any)` | `[]` | no |
| allowed\_virtual\_network\_subnet\_ids | A list of resource ids for subnets | `list(any)` | `[]` | no |
| bypass | Specifies which traffic can bypass the network rules. Possible values are AzureServices and None | `string` | n/a | yes |
| default\_action | The Default Action to use when no rules match from ip\_rules / virtual\_network\_subnet\_ids. Possible values are Allow and Deny | `string` | `"Deny"` | no |
| diag\_name | The diagnostic setting name | `string` | `""` | no |
| enable\_logs | Deploy diagnostic settings true/false | `string` | `"false"` | no |
| enable\_rbac\_authorization | Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Defaults to false | `bool` | `true` | no |
| enabled\_for\_deployment | Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Defaults to false | `bool` | `false` | no |
| enabled\_for\_disk\_encryption | Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false | `bool` | `false` | no |
| enabled\_for\_template\_deployment | Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Defaults to false | `bool` | `false` | no |
| location | List of organisation wise approved region for workload deployment | `string` | n/a | yes |
| log\_analytics\_workspace\_id | (Optional) Log analytics workspace ID to use for the logs | `string` | `null` | no |
| name | Name of the KeyVault | `string` | n/a | yes |
| purge\_protection\_enabled | Is Purge Protection enabled for this Key Vault? Defaults to false | `bool` | `true` | no |
| resource\_group\_name | Resource Group Name for the KeyVault | `string` | n/a | yes |
| retention\_days | The number of days for which this Retention Policy should apply for logging | `number` | `365` | no |
| sku\_name | The Name of the SKU used for this Key Vault. Possible values are standard and premium | `string` | `"standard"` | no |
| soft\_delete\_retention\_days | The number of days that items should be retained for once soft-deleted | `number` | `90` | no |
| storage\_account\_id | Storage account ID to use for the logs | `string` | `""` | no |
| tenant\_id | The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Key Vault |
| name | The name of the Key Vault |
| vault\_uri | The URI of the Key Vault, used for performing operations on keys and secrets |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
