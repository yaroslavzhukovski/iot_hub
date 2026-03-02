output "vnet_id" {
  description = "Virtual Network resource ID."
  value       = module.vnet.resource_id
}

output "vnet_name" {
  description = "Virtual Network name."
  value       = module.vnet.name
}

output "subnet_ids" {
  description = "Map of subnet IDs keyed by subnet map keys."
  value       = { for k, s in module.vnet.subnets : k => s.resource_id }
}

output "subnet_names" {
  description = "Map of subnet names keyed by subnet map keys."
  value       = { for k, s in module.vnet.subnets : k => s.name }
}
