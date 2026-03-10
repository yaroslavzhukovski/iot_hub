output "storage_endpoint_id" {
  description = "IoT Hub storage endpoint ID (if enabled)."
  value       = try(one(azurerm_iothub_endpoint_storage_container.storage[*].id), null)
}

output "storage_route_id" {
  description = "IoT Hub storage route ID (if enabled)."
  value       = try(one(azurerm_iothub_route.storage[*].id), null)
}

output "events_route_id" {
  description = "IoT Hub events route ID."
  value       = azurerm_iothub_route.events.id
}

output "events_consumer_group_name" {
  description = "Dedicated consumer group name for built-in events endpoint (if enabled)."
  value       = try(one(azurerm_iothub_consumer_group.events[*].name), null)
}

output "events_consumer_group_id" {
  description = "Dedicated consumer group ID for built-in events endpoint (if enabled)."
  value       = try(one(azurerm_iothub_consumer_group.events[*].id), null)
}

output "fallback_route_id" {
  description = "IoT Hub fallback route ID (if enabled)."
  value       = try(one(azurerm_iothub_fallback_route.this[*].id), null)
}
