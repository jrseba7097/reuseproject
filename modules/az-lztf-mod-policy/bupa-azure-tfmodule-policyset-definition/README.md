# README

Terraform module to generate Azure Policy Set Definition

## Usage Examples

```
module "policy_set_location" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-policyset-definition"

  name                         = local.name
  display_name                 = local.display_name
  description                  = local.description
  holder_management_group_name = var.holder_management_group_name

  policies = [
    {
      policyID = azurerm_policy_definition.test_definition.id
      parameters = <<VALUE
        {
          "allowedLocations": {"value": "[parameters('allowedLocations')]"}
        }
VALUE
    }
  ]
  parameters = <<PARAMETERS
    {
        "allowedLocations": {
            "type": "Array",
            "metadata": {
                "description": "The list of allowed locations for resources.",
                "displayName": "Allowed locations",
                "strongType": "location"
            }
        }
    }
PARAMETERS
}

variable "holder_management_group_name" {
  type        = string
  description = "Management group name to store policies"
  default     = "CloudTechServ"
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
| description | The description of the policy set definition. | `string` | n/a | yes |
| display\_name | The display name of the policy set definition. | `string` | n/a | yes |
| holder\_management\_group\_name | Management group name to store policies | `string` | n/a | yes |
| name | The name of the policy set definition. | `string` | n/a | yes |
| parameters | Policy set parameters | `string` | n/a | yes |
| policies | List of policy definitions ids and their parameters | `list(map(string))` | n/a | yes |
| policy\_type | The policy set type. | `string` | `"Custom"` | no |
| policyset\_definition\_category | The category to use for the PolicySet metadata | `string` | `"Custom"` | no |

## Outputs

| Name | Description |
|------|-------------|
| policyset\_id | The policy set definition id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
