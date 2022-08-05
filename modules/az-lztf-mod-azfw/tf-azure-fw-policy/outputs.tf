output "id" {
  value       = azurerm_firewall_policy.main.id
  description = "The ID of the Firewall Policy"
}

output "firewalls" {
  value       = azurerm_firewall_policy.main.firewalls
  description = "A list of references to Azure Firewalls that this Firewall Policy is associated with"
}

output "rule_collection_groups" {
  value       = azurerm_firewall_policy.main.rule_collection_groups
  description = "A list of references to Firewall Policy Rule Collection Groups that belongs to this Firewall Policy"
}
