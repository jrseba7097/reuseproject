## Usage Examples

```
module "storage_account" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-storageaccount"

  name                     = local.sa_name
  resource_group_name      = azurerm_resource_group.test.name
  location                 = local.location
  bypass                   = var.bypass
  account_replication_type = var.account_replication_type
}

```
# README

Terraform module to generate Azure Storage Account and its containers

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
| access\_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot | `string` | `"Hot"` | no |
| account\_kind | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Changing this forces a new resource to be created. Defaults to StorageV2 | `string` | `"StorageV2"` | no |
| account\_replication\_type | Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS | `string` | n/a | yes |
| account\_tier | Defines the Tier to use for this storage account. Valid options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid. Changing this forces a new resource to be created | `string` | `"Standard"` | no |
| allowed\_ip\_ranges | List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. Private IP address ranges (as defined in RFC 1918) are not allowed | `list(string)` | `[]` | no |
| allowed\_virtual\_network\_subnet\_ids | A list of resource ids for subnets | `list(string)` | `[]` | no |
| bypass | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None | `list(string)` | n/a | yes |
| containers | A list of containers to be created in the storage account | `list(string)` | `[]` | no |
| default\_action | Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow | `string` | `"Deny"` | no |
| delete\_retention\_policy\_days | Specifies the number of days that the blob should be retained, between 1 and 365 days. Defaults to 7 | `number` | `7` | no |
| location | The full (Azure) location identifier for the storage account | `string` | n/a | yes |
| name | Specifies the name of the storage account. Changing this forces a new resource to be created. This must be unique across the entire Azure service, not just within the resource group | `string` | n/a | yes |
| resource\_group\_name | Resource Group to deploy the storage account to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Storage Account. |
| name | The name of the Storage Account. |
| primary\_access\_key | The primary access key for the storage account. |
| primary\_connection\_string | The connection string associated with the primary location. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
