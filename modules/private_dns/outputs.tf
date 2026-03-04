output "zone_ids" {
  description = "Map of private DNS zone IDs keyed by logical zone key."
  value       = { for k, v in azurerm_private_dns_zone.this : k => v.id }
}

output "zone_names" {
  description = "Map of private DNS zone names keyed by logical zone key."
  value       = { for k, v in azurerm_private_dns_zone.this : k => v.name }
}

output "vnet_link_ids" {
  description = "Map of private DNS VNet link IDs keyed by '<zone_key>|<vnet_key>'."
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.this : k => v.id }
}
