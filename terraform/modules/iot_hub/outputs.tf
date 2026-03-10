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

output "event_hub_events_path" {
  description = "Built-in Event Hub-compatible path for device-to-cloud messages."
  value       = azurerm_iothub.this.event_hub_events_path
}

output "event_hub_events_fqdn" {
  description = "Built-in Event Hub-compatible fully qualified namespace."
  value       = trimsuffix(trimprefix(azurerm_iothub.this.event_hub_events_endpoint, "sb://"), "/")
}

output "event_hub_compatible_connection_string" {
  description = "Event Hub-compatible connection string for the IoT Hub built-in events endpoint."
  value       = "Endpoint=${azurerm_iothub.this.event_hub_events_endpoint};SharedAccessKeyName=${azurerm_iothub_shared_access_policy.function_ingest.name};SharedAccessKey=${azurerm_iothub_shared_access_policy.function_ingest.primary_key};EntityPath=${azurerm_iothub.this.event_hub_events_path}"
  sensitive   = true
}
