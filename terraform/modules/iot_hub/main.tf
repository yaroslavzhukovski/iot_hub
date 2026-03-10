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

  lifecycle {
    ignore_changes = [
      endpoint,
      route,
      fallback_route
    ]
  }
}

resource "azurerm_iothub_shared_access_policy" "function_ingest" {
  name                = "function-ingest"
  resource_group_name = var.resource_group_name
  iothub_name         = azurerm_iothub.this.name

  service_connect = true
}
