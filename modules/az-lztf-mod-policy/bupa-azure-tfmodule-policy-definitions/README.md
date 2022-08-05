# README

Terraform module to generate Azure Policy Definitions

## Usage Examples

```
module "policy_definitions" {
  source = "git@ssh.dev.azure.com:v3/BupaCloudServices/Azure%20Remediation/bupa-azure-tfmodule-policy-definitions?ref=v1.0.0"

  providers = {
     azurerm = azurerm.governance
  }

  holder_management_group_name = var.holder_management_group_name
  mandatory_tag_keys           = var.mandatory_tag_keys
}

variable "mandatory_tag_keys" {
  type        = list(any)
  description = "List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG'"
  default = [
    "Owner ID",
    "Billing",
    "IT Service",
    "ENV",
    "Project"
  ]
}

variable "holder_management_group_name" {
  type        = string
  description = "Management group name to store policies"
}

mandatory_tag_keys = [
    "Owner ID",
    "Billing",
    "IT Service",
    "ENV",
    "Project"
  ]

holder_management_group_name = "BupaHubMaster"

```

## Terraform resources

| Resource Type             | Resource name                              | Deployment Count
|:--------------------------|:-------------------------------------------|:------
| azurerm_policy_definition | `addTagToRG`                               | 5
| azurerm_policy_definition | `inheritTagFromRG`                         | 5
| azurerm_policy_definition | `inheritTagFromRGOverwriteExisting`        | 5
| azurerm_policy_definition | `auditRoleAssignmentType_user`             | 1
| azurerm_policy_definition | `allowedlocations`                         | 1
| azurerm_policy_definition | `audit_subnet_without_nsg`                 | 1
| azurerm_policy_definition | `deny_publicip_spoke`                      | 1
| azurerm_policy_definition | `deny_publicips_on_nics`                   | 1

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
| holder\_management\_group\_name | Management group name to store policies | `string` | n/a | yes |
| mandatory\_tag\_keys | List of mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG' | `list(string)` | <pre>[<br>  "Owner ID",<br>  "Billing",<br>  "IT Service",<br>  "ENV",<br>  "Project"<br>]</pre> | no |
| mandatory\_tag\_value | Tag value to include with the mandatory tag keys used by policies 'addTagToRG','inheritTagFromRG' | `string` | `"TBC"` | no |
| policy\_definition\_category | The category to use for all Policy Definitions | `string` | `"Custom"` | no |

## Outputs

| Name | Description |
|------|-------------|
| addTagToRG\_policy\_ids | The policy definition ids for addTagToRG policies |
| allow\_vm\_skus\_definition\_policy\_id | The policy definition id for allowed vm skus |
| allowedlocations\_policy\_id | The policy definition id for allowedlocations |
| audit\_storage\_encryption\_policy\_id | The policy definition id for audit storage custom-managed encryption |
| audit\_storage\_public\_policy\_id | The policy definition id for audit storage public |
| audit\_subnet\_without\_nsg\_policy\_id | The policy definition id for audit\_subnet\_without\_nsg |
| audit\_subnet\_without\_udr\_policy\_id | The policy definition id for audit\_subnet\_without\_udr\_policy\_id |
| deny\_all\_inbound\_policy\_id | The policy definition id for deny NSG rule with allow all inbound |
| deny\_publicip\_spoke\_policy\_id | The policy definition id for deny\_publicip\_spoke |
| deny\_publicips\_on\_nics\_policy\_id | The policy definition id for deny\_publicips\_on\_nics |
| deploy\_storage\_advanced\_threat\_policy\_id | The policy definition id for deploy storage advanced threat |
| inheritTagFromRGOverwriteExisting\_policy\_ids | The policy definition ids for inheritTagFromRGOverwriteExisting policies |
| inheritTagFromRG\_policy\_ids | The policy definition ids for inheritTagFromRG policies |
| require\_rg\_tag\_match\_policy\_id | The policy definition id for deploy require Resource Group tag match |
| require\_rg\_tag\_policy\_id | The policy definition id for deploy require Resource Group tag |
| require\_storage\_file\_encryption\_policy\_id | The policy definition id for deploy require storage file encryption |
| require\_storage\_https\_only\_policy\_id | The policy definition id for deploy require storage https only |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
