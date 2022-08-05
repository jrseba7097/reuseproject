# README

Terraform module to generate Azure Management Groups hierarchy

## Usage Examples

```
module "management_groups" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-management-groups?ref=v1.0.0"

  providers = {
     azurerm = azurerm.governance
  }

  management_groups          = var.management_groups
  parent_management_group_id = var.parent_management_group_id
}

variable "management_groups" {
  type = object({
    name             = string
    display_name     = string
    subscription_ids = list(string)
    children         = list(any)
  })
  description = "Management groups hierarchy"
}

variable "parent_management_group_id" {
  type      = string
  description = "Management group id where the MG hierarchy starts"
}
```

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
| management\_groups | Management groups object defining the hierarchy | `any` | n/a | yes |
| parent\_management\_group\_id | Parent Management group id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| management_group_id | Management group id |
| children_management_group_ids | Children Management group ids |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
