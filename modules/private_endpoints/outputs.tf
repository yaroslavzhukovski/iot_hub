output "private_endpoint_ids" {
  description = "Map of private endpoint IDs keyed by logical key."
  value       = { for k, pe in azurerm_private_endpoint.this : k => pe.id }
}

output "network_interface_ids" {
  description = "Map of network interface IDs for private endpoints keyed by logical key."
  value       = { for k, pe in azurerm_private_endpoint.this : k => pe.network_interface[0].id }
}

output "private_ip_addresses" {
  description = "Map of private IP addresses keyed by logical key."
  value       = { for k, pe in azurerm_private_endpoint.this : k => pe.private_service_connection[0].private_ip_address }
}
