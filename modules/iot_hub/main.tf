data "azurerm_client_config" "current" {}

locals {
  effective_storage_subscription_id = coalesce(var.storage_account_subscription_id, data.azurerm_client_config.current.subscription_id)
  effective_eventhub_subscription_id = coalesce(var.eventhub_subscription_id, data.azurerm_client_config.current.subscription_id)
}

resource "azurerm_iothub" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  min_tls_version               = "1.2"
  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled

  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
  }

  identity {
    type = "SystemAssigned"
  }
  network_rule_set {
    default_action                     = var.network_rule_default_action
    apply_to_builtin_eventhub_endpoint = var.network_rule_apply_to_builtin_eventhub_endpoint

    dynamic "ip_rule" {
      for_each = var.ip_rules
      content {
        name    = ip_rule.value.name
        ip_mask = ip_rule.value.ip_mask
        action  = ip_rule.value.action
      }
    }
  }

  endpoint = concat(
    [
      {
        type                       = "AzureIotHub.StorageContainer"
        authentication_type        = "identityBased"
        name                       = var.storage_endpoint_name
        batch_frequency_in_seconds = var.storage_batch_frequency_in_seconds
        max_chunk_size_in_bytes    = var.storage_max_chunk_size_in_bytes
        container_name             = var.storage_container_name
        encoding                   = var.storage_encoding
        file_name_format           = var.storage_file_name_format
        resource_group_name        = var.storage_account_resource_group_name
        subscription_id            = local.effective_storage_subscription_id
        connection_string          = null
        endpoint_uri               = null
        entity_path                = null
        identity_id                = null
      }
    ],
    var.enable_custom_eventhub_endpoint ? [
      {
        type                       = "AzureIotHub.EventHub"
        authentication_type        = "identityBased"
        name                       = var.eventhub_endpoint_name
        resource_group_name        = var.eventhub_resource_group_name
        subscription_id            = local.effective_eventhub_subscription_id
        endpoint_uri               = var.eventhub_endpoint_uri
        entity_path                = var.eventhub_entity_path
        connection_string          = null
        identity_id                = null
        batch_frequency_in_seconds = null
        max_chunk_size_in_bytes    = null
        container_name             = null
        encoding                   = null
        file_name_format           = null
      }
    ] : []
  )

  route = [
    {
      name           = var.storage_route_name
      source         = "DeviceMessages"
      condition      = var.storage_route_condition
      endpoint_names = [var.storage_endpoint_name]
      enabled        = true
    },
    {
      name           = var.events_route_name
      source         = "DeviceMessages"
      condition      = var.events_route_condition
      endpoint_names = [var.enable_custom_eventhub_endpoint ? var.eventhub_endpoint_name : var.built_in_events_endpoint_name]
      enabled        = true
    }
  ]

  fallback_route {
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = [var.built_in_events_endpoint_name]
    enabled        = var.fallback_route_enabled
  }

  cloud_to_device {
    max_delivery_count = 30
    default_ttl        = "PT1H"
    feedback {
      time_to_live       = "PT1H10M"
      max_delivery_count = 15
      lock_duration      = "PT30S"
    }
  }

  tags = var.tags
}
