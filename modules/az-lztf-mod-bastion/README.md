# README

Terraform module to generate Azure Bastion Host with its Public IP.

## Usage Examples

```
module "bastion" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-bastion"

  name                  = local.bastion_host_name
  location              = azurerm_resource_group.RG.location
  resource_group_name   = azurerm_resource_group.RG.name
  ip_configuration_name = local.bastion_ip_configuration_name
  public_ip_name        = local.bastion_public_ip_name
  subnet_id             = module.primary_trust_vnet.subnet_ids[3]
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
| allocation\_method | Defines the allocation method for this IP address. Possible values are Static or Dynamic | `string` | `"Static"` | no |
| ip\_configuration\_name | Name to assign to the IP configuration | `string` | n/a | yes |
| location | The full (Azure) location identifier for the Resource Group | `string` | n/a | yes |
| name | Name to assign to the Bastion host.Changing this forces a new resource to be created | `string` | n/a | yes |
| public\_ip\_name | Name to assign to the Public IP | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Bastion Host | `string` | n/a | yes |
| sku | The SKU of the Public IP. Accepted values are Basic and Standard. Defaults to Basic | `string` | `"Basic"` | no |
| subnet\_id | Reference to a subnet in which this Bastion Host has been created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Bastion Host. |
| name | The name of the Bastion Host. |
| public\_ip\_id | Public IP Address ID associated with this Bastion Host. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
