output "addTagToRG_policy_ids" {
  value       = module.testing.addTagToRG_policy_ids
  description = "The policy definition ids for addTagToRG policies"
}

output "inheritTagFromRG_policy_ids" {
  value       = module.testing.inheritTagFromRG_policy_ids
  description = "The policy definition ids for inheritTagFromRG policies"
}

output "inheritTagFromRGOverwriteExisting_policy_ids" {
  value       = module.testing.inheritTagFromRGOverwriteExisting_policy_ids
  description = "The policy definition ids for inheritTagFromRGOverwriteExisting policies"
}

output "deny_publicips_on_nics_policy_id" {
  value       = module.testing.deny_publicips_on_nics_policy_id
  description = "The policy definition id for deny_publicips_on_nics"
}

output "deny_publicip_spoke_policy_id" {
  value       = module.testing.deny_publicip_spoke_policy_id
  description = "The policy definition id for deny_publicip_spoke"
}

output "allowedlocations_policy_id" {
  value       = module.testing.allowedlocations_policy_id
  description = "The policy definition id for allowedlocations"
}

output "audit_subnet_without_nsg_policy_id" {
  value       = module.testing.audit_subnet_without_nsg_policy_id
  description = "The policy definition id for audit_subnet_without_nsg"
}
