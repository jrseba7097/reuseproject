output "allowedlocations_policy_id" {
  value       = azurerm_policy_definition.allowedlocations.id
  description = "The policy definition id for allowedlocations"
}

output "allow_vm_skus_definition_policy_id" {
  value       = azurerm_policy_definition.policy_allow_vm_skus_definition.id
  description = "The policy definition id for allowed vm skus"
}

output "audit_storage_encryption_policy_id" {
  value       = azurerm_policy_definition.audit_storage_encryption.id
  description = "The policy definition id for audit storage custom-managed encryption"
}

output "audit_storage_public_policy_id" {
  value       = azurerm_policy_definition.audit_storage_public.id
  description = "The policy definition id for audit storage public"
}

output "audit_subnet_without_nsg_policy_id" {
  value       = azurerm_policy_definition.audit_subnet_without_nsg.id
  description = "The policy definition id for audit_subnet_without_nsg"
}

output "audit_subnet_without_udr_policy_id" {
  value       = azurerm_policy_definition.audit_subnet_udr.id
  description = "The policy definition id for audit_subnet_without_udr_policy_id"
}

output "deny_all_inbound_policy_id" {
  value       = azurerm_policy_definition.deny_all_inbound.id
  description = "The policy definition id for deny NSG rule with allow all inbound"
}

output "deny_publicip_spoke_policy_id" {
  value       = azurerm_policy_definition.deny_publicip_spoke.id
  description = "The policy definition id for deny_publicip_spoke"
}

output "deny_publicips_on_nics_policy_id" {
  value       = azurerm_policy_definition.deny_publicips_on_nics.id
  description = "The policy definition id for deny_publicips_on_nics"
}

output "deploy_storage_advanced_threat_policy_id" {
  value       = azurerm_policy_definition.deploy_storage_advanced_threat.id
  description = "The policy definition id for deploy storage advanced threat"
}

output "require_rg_tag_match_policy_id" {
  value       = azurerm_policy_definition.require_rg_tag_match.id
  description = "The policy definition id for deploy require Resource Group tag match"
}

output "require_rg_tag_policy_id" {
  value       = azurerm_policy_definition.require_rg_tag.id
  description = "The policy definition id for deploy require Resource Group tag"
}

output "require_storage_file_encryption_policy_id" {
  value       = azurerm_policy_definition.require_storage_file_encryption.id
  description = "The policy definition id for deploy require storage file encryption"
}

output "require_storage_https_only_policy_id" {
  value       = azurerm_policy_definition.require_storage_https_only.id
  description = "The policy definition id for deploy require storage https only"
}

output "addTagToRG_policy_ids" {
  value       = azurerm_policy_definition.addTagToRG.*.id
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = azurerm_policy_definition.inheritTagFromRG.*.id
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "inheritTagFromRGOverwriteExisting_policy_ids" {
  value       = azurerm_policy_definition.inheritTagFromRGOverwriteExisting.*.id
  description = "The policy definition ids for inheritTagFromRGOverwriteExisting policies"
}
