output "vnet_name" {
  value       = module.testing.vnet_name
  description = "Vnet name"
}

output "address_space" {
  value       = module.testing.address_space
  description = "Vnet address space"
}

output "subnet_ids" {
  value       = module.testing.subnet_ids
  description = "Subnet Ids in the Vnet"
}
