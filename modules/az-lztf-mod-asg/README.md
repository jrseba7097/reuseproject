# README

Terraform module to generate Azure Application Security Group.

## Usage Examples

```
module "asg" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-application-security-group"

  name                = local.asg_name
  location            = azurerm_resource_group.RG.location
  resource_group_name = azurerm_resource_group.RG.name
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
| location | The full (Azure) location identifier for the ASG | `string` | n/a | yes |
| name | Specifies the name of the application security group. Changing this forces a new resource to be created | `string` | n/a | yes |
| network\_interface\_id | List of IDs of the Network Interfaces to associate. | `list(string)` | `[]` | no |
| resource\_group\_name | Resource Group to deploy the ASG to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Application Security Group. |
| name | The name of the Application Security Group. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
