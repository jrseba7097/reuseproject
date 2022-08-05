# README

Terraform module to generate Azure Policy Assignments

## Usage Examples

```
module "network_policy_set_assignment" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-policy-assignments"

  providers = {
    azurerm = azurerm.governance
  }

  name                 = "bupaNetwork"
  display_name         = "Bupa Network policy set"
  description          = "Bupa Network policy set including NSG, UDR and public IP policies"
  policy_definition_id = module.network_policy_set.policyset_id
  scope                = var.scope_id

  metadata = <<METADATA
    {
    "category": "Network"
    }
METADATA
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
| description | The policy assignment description | `string` | n/a | yes |
| display\_name | The policy assignment display name | `string` | n/a | yes |
| enable\_identity | Enable policy assignment identity | `bool` | `false` | no |
| location | The policy assignment location, needed if identity is enabled | `string` | `null` | no |
| metadata | The policy assignment metadata | `string` | `null` | no |
| name | The policy assignment name | `string` | n/a | yes |
| parameters | The policy assignment parameters | `string` | `null` | no |
| policy\_definition\_id | The policy definition id | `string` | n/a | yes |
| scope | The policy assignment scope id | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
