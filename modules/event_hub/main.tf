resource "azurerm_eventhub_namespace" "this" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.namespace_sku
  capacity            = var.namespace_capacity

  local_authentication_enabled  = var.local_authentication_enabled
  public_network_access_enabled = var.public_network_access_enabled
  minimum_tls_version           = "1.2"
  network_rulesets = [
    {
      default_action                 = var.network_rules_default_action
      public_network_access_enabled  = var.public_network_access_enabled
      trusted_service_access_enabled = var.trusted_service_access_enabled
      ip_rule                        = []
      virtual_network_rule           = []
    }
  ]

  tags = var.tags
}

resource "azurerm_eventhub" "this" {
  name              = var.eventhub_name
  namespace_id      = azurerm_eventhub_namespace.this.id
  partition_count   = var.partition_count
  message_retention = var.message_retention
}
