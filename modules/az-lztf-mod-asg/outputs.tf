output "id" {
  value       = azurerm_application_security_group.asg.id
  description = "The ID of the Application Security Group."
}

output "name" {
  value       = azurerm_application_security_group.asg.name
  description = "The name of the Application Security Group."
}
