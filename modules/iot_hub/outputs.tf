output "id" {
  description = "IoT Hub resource ID."
  value       = azurerm_iothub.this.id
}

output "name" {
  description = "IoT Hub name."
  value       = azurerm_iothub.this.name
}

output "hostname" {
  description = "IoT Hub hostname."
  value       = azurerm_iothub.this.hostname
}

output "identity_principal_id" {
  description = "System-assigned managed identity principal ID of IoT Hub."
  value       = azurerm_iothub.this.identity[0].principal_id
}

output "event_hub_events_endpoint" {
  description = "Built-in Event Hub-compatible endpoint for device-to-cloud messages."
  value       = azurerm_iothub.this.event_hub_events_endpoint
}
