data "azurerm_client_config" "current" {}

locals {
  effective_storage_subscription_id = coalesce(var.storage_account_subscription_id, data.azurerm_client_config.current.subscription_id)
}

resource "azurerm_iothub_endpoint_storage_container" "storage" {
  count = var.enable_storage_endpoint ? 1 : 0

  name                       = var.storage_endpoint_name
  iothub_id                  = var.iothub_id
  resource_group_name        = var.resource_group_name
  container_name             = var.storage_container_name
  endpoint_uri               = var.storage_endpoint_uri
  authentication_type        = "identityBased"
  batch_frequency_in_seconds = var.storage_batch_frequency_in_seconds
  max_chunk_size_in_bytes    = var.storage_max_chunk_size_in_bytes
  encoding                   = var.storage_encoding
  file_name_format           = var.storage_file_name_format
  subscription_id            = local.effective_storage_subscription_id
}

resource "azurerm_iothub_route" "storage" {
  count = var.enable_storage_endpoint ? 1 : 0

  name                = var.storage_route_name
  resource_group_name = var.resource_group_name
  iothub_name         = var.iothub_name
  source              = "DeviceMessages"
  condition           = var.storage_route_condition
  endpoint_names      = [azurerm_iothub_endpoint_storage_container.storage[0].name]
  enabled             = true

  depends_on = [azurerm_iothub_endpoint_storage_container.storage]
}

resource "azurerm_iothub_route" "events" {
  name                = var.events_route_name
  resource_group_name = var.resource_group_name
  iothub_name         = var.iothub_name
  source              = "DeviceMessages"
  condition           = var.events_route_condition
  endpoint_names      = [var.built_in_events_endpoint_name]
  enabled             = true

  # IoT Hub routing updates are sensitive to parallel writes; enforce sequence.
  depends_on = [
    azurerm_iothub_endpoint_storage_container.storage,
    azurerm_iothub_route.storage
  ]
}

resource "azurerm_iothub_consumer_group" "events" {
  count = var.enable_events_consumer_group ? 1 : 0

  name                   = var.events_consumer_group_name
  iothub_name            = var.iothub_name
  resource_group_name    = var.resource_group_name
  eventhub_endpoint_name = var.built_in_events_endpoint_name

  depends_on = [azurerm_iothub_route.events]
}

resource "azurerm_iothub_fallback_route" "this" {
  count = var.fallback_route_enabled ? 1 : 0

  resource_group_name = var.resource_group_name
  iothub_name         = var.iothub_name
  source              = "DeviceMessages"
  condition           = "true"
  endpoint_names      = [var.built_in_events_endpoint_name]
  enabled             = true
}
