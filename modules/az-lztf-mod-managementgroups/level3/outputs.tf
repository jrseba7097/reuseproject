output "management_group_id" {
  value       = azurerm_management_group.mg.id
  description = "Management group id"
}

output "children_management_group_ids" {
  value       = module.children.*.management_group_id
  description = "Children Management group ids"
}
