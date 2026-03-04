data "azurerm_client_config" "current" {}

locals {
  effective_tenant_id = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)
}

module "naming" {
  source = "../../modules/naming"

  project                = var.project
  environment            = var.environment
  location               = var.location
  instance               = var.instance
  global_suffix_length   = var.global_suffix_length
  region_short_overrides = var.region_short_overrides
  owner                  = var.owner
  cost_center            = var.cost_center
  data_classification    = var.data_classification
  additional_tags        = var.additional_tags
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = module.naming.names.resource_group
  location = var.location
  tags     = module.naming.tags
}

module "network" {
  source = "../../modules/network"

  vnet_name                   = module.naming.names.vnet
  location                    = var.location
  parent_id                   = module.resource_group.id
  address_space               = var.network_address_space
  subnets                     = var.subnets
  flow_timeout_in_minutes     = var.flow_timeout_in_minutes
  enable_vnet_encryption      = var.enable_vnet_encryption
  vnet_encryption_enforcement = var.vnet_encryption_enforcement
  enable_telemetry            = var.enable_network_telemetry
  tags                        = module.naming.tags
}

module "storage" {
  source = "../../modules/storage"

  storage_account_name = module.naming.names.storage_account
  resource_group_name  = module.resource_group.name
  location             = var.location
  tags                 = module.naming.tags
}

module "private_dns" {
  source = "../../modules/private_dns"

  resource_group_name  = module.resource_group.name
  private_dns_zones    = var.private_dns_zones
  vnet_ids             = { core = module.network.vnet_id }
  registration_enabled = var.registration_enabled
  tags                 = module.naming.tags
}

module "key_vault" {
  source = "../../modules/key_vault"

  key_vault_name             = module.naming.names.key_vault
  location                   = var.location
  resource_group_name        = module.resource_group.name
  tags                       = module.naming.tags
  tenant_id                  = local.effective_tenant_id
  sku_name                   = var.key_vault_sku_name
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled

}

module "digital_twins" {
  source = "../../modules/digital_twins"

  name                = module.naming.names.digital_twins
  resource_group_name = module.resource_group.name
  location            = var.digital_twins_location
  tags                = module.naming.tags
}

module "private_endpoints" {
  source = "../../modules/private_endpoints"

  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.network.subnet_ids["private_endpoints"]
  tags                = module.naming.tags

  private_endpoints = {
    storage_blob = {
      name                 = "pe-${module.naming.base_name}-blob"
      target_resource_id   = module.storage.storage_account_id
      subresource_names    = ["blob"]
      private_dns_zone_ids = [module.private_dns.zone_ids["blob"]]
    }
    key_vault = {
      name                 = "pe-${module.naming.base_name}-kv"
      target_resource_id   = module.key_vault.id
      subresource_names    = ["vault"]
      private_dns_zone_ids = [module.private_dns.zone_ids["key_vault"]]
    }
    digital_twins = {
      name                 = "pe-${module.naming.base_name}-adt"
      target_resource_id   = module.digital_twins.id
      subresource_names    = ["API"]
      private_dns_zone_ids = [module.private_dns.zone_ids["digital_twins"]]
    }
    event_hub_namespace = {
      name                 = "pe-${module.naming.base_name}-ehns"
      target_resource_id   = module.event_hub.namespace_id
      subresource_names    = ["namespace"]
      private_dns_zone_ids = [module.private_dns.zone_ids["servicebus"]]
    }
  }
}

module "event_hub" {
  source = "../../modules/event_hub"

  namespace_name                 = "ehns-${module.naming.base_name}"
  eventhub_name                  = "iot-ingress"
  resource_group_name            = module.resource_group.name
  location                       = var.location
  namespace_sku                  = var.eventhub_namespace_sku
  namespace_capacity             = var.eventhub_namespace_capacity
  partition_count                = var.eventhub_partition_count
  message_retention              = var.eventhub_message_retention
  public_network_access_enabled  = var.eventhub_public_network_access_enabled
  local_authentication_enabled   = var.eventhub_local_authentication_enabled
  trusted_service_access_enabled = var.eventhub_trusted_service_access_enabled
  tags                           = module.naming.tags
}

module "iot_hub" {
  source = "../../modules/iot_hub"

  name                                            = module.naming.names.iot_hub
  resource_group_name                             = module.resource_group.name
  location                                        = var.location
  public_network_access_enabled                   = var.iot_hub_public_network_access_enabled
  local_authentication_enabled                    = var.iot_hub_local_authentication_enabled
  storage_container_name                          = module.storage.digital_twin_data_container_name
  storage_account_resource_group_name             = module.resource_group.name
  storage_account_subscription_id                 = var.subscription_id
  enable_custom_eventhub_endpoint                 = true
  eventhub_endpoint_name                          = "eventhub-custom"
  eventhub_resource_group_name                    = module.resource_group.name
  eventhub_subscription_id                        = var.subscription_id
  eventhub_endpoint_uri                           = module.event_hub.namespace_endpoint
  eventhub_entity_path                            = module.event_hub.eventhub_name
  network_rule_default_action                     = var.iot_hub_network_rule_default_action
  network_rule_apply_to_builtin_eventhub_endpoint = var.iot_hub_network_rule_apply_to_builtin_eventhub_endpoint
  ip_rules                                        = var.iot_hub_ip_rules
  tags                                            = module.naming.tags
}

module "function_flex" {
  source = "../../modules/function_flex"

  service_plan_name          = "asp-${module.naming.base_name}-fc"
  function_app_name          = module.naming.names.function_app
  resource_group_name        = module.resource_group.name
  location                   = var.location
  subnet_id                  = module.network.subnet_ids["function_integration"]
  storage_container_endpoint = module.storage.functions_deployment_container_url
  storage_blob_service_uri   = module.storage.blob_service_uri
  extra_app_settings = {
    "IotIngest__fullyQualifiedNamespace"        = module.event_hub.namespace_fqdn
    "IotIngest__eventHubName"                   = module.event_hub.eventhub_name
    "APPLICATIONINSIGHTS_AUTHENTICATION_STRING" = "Authorization=AAD"
  }
  tags = module.naming.tags
}


