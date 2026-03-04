output "namespace_id" {
  description = "Event Hubs namespace ID."
  value       = azurerm_eventhub_namespace.this.id
}

output "namespace_name" {
  description = "Event Hubs namespace name."
  value       = azurerm_eventhub_namespace.this.name
}

output "namespace_endpoint" {
  description = "Event Hubs namespace endpoint (sb://...)."
  value       = "sb://${azurerm_eventhub_namespace.this.name}.servicebus.windows.net/"
}

output "namespace_fqdn" {
  description = "Event Hubs namespace FQDN for Functions identity-based connection."
  value       = "${azurerm_eventhub_namespace.this.name}.servicebus.windows.net"
}

output "eventhub_id" {
  description = "Event Hub ID."
  value       = azurerm_eventhub.this.id
}

output "eventhub_name" {
  description = "Event Hub name."
  value       = azurerm_eventhub.this.name
}
