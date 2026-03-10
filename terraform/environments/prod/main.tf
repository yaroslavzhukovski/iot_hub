data "azurerm_client_config" "current" {}

locals {
  effective_tenant_id = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)

  required_rbac_assignments = {
    iothub_to_storage_blob_contributor = {
      scope                = module.storage.storage_account_id
      principal_id         = module.iot_hub.identity_principal_id
      role_definition_name = "Storage Blob Data Contributor"
      principal_type       = "ServicePrincipal"
    }
    function_to_eventhub_receiver = {
      scope                = module.iot_hub.id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Azure Event Hubs Data Receiver"
      principal_type       = "ServicePrincipal"
    }
    function_to_storage_blob_contributor = {
      scope                = module.storage.storage_account_id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Storage Blob Data Contributor"
      principal_type       = "ServicePrincipal"
    }
    function_to_storage_queue_contributor = {
      scope                = module.storage.storage_account_id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Storage Queue Data Contributor"
      principal_type       = "ServicePrincipal"
    }
    function_to_storage_table_contributor = {
      scope                = module.storage.storage_account_id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Storage Table Data Contributor"
      principal_type       = "ServicePrincipal"
    }
    function_to_keyvault_secrets_user = {
      scope                = module.key_vault.id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Key Vault Secrets User"
      principal_type       = "ServicePrincipal"
    }
    function_to_digital_twins_data_owner = {
      scope                = module.digital_twins.id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Azure Digital Twins Data Owner"
      principal_type       = "ServicePrincipal"
    }
    function_to_appinsights_metrics_publisher = {
      scope                = module.observability_core.application_insights_id
      principal_id         = module.function_flex.function_app_principal_id
      role_definition_name = "Monitoring Metrics Publisher"
      principal_type       = "ServicePrincipal"
    }
  }

  diagnostic_targets = {
    iot_hub = {
      target_resource_id = module.iot_hub.id
    }
    storage = {
      target_resource_id = module.storage.storage_account_id
    }
    storage_blob_service = {
      target_resource_id = "${module.storage.storage_account_id}/blobServices/default"
    }
    key_vault = {
      target_resource_id = module.key_vault.id
    }
    digital_twins = {
      target_resource_id = module.digital_twins.id
    }
    function_flex = {
      target_resource_id = module.function_flex.function_app_id
    }
  }
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

module "observability_core" {
  source = "../../modules/observability_core"

  resource_group_name                       = module.resource_group.name
  location                                  = var.location
  log_analytics_workspace_name              = module.naming.names.log_analytics
  application_insights_name                 = module.naming.names.app_insights
  log_analytics_retention_in_days           = var.log_analytics_retention_in_days
  log_analytics_daily_quota_gb              = var.log_analytics_daily_quota_gb
  application_insights_daily_data_cap_in_gb = var.application_insights_daily_data_cap_in_gb
  application_insights_sampling_percentage  = var.application_insights_sampling_percentage
  tags                                      = module.naming.tags
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

module "nsg_function_integration" {
  source = "../../modules/nsg"

  nsg_name            = "nsg-func-${module.naming.base_name}"
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_id           = module.network.subnet_ids["function_integration"]
  security_rules      = []
  tags                = module.naming.tags
}

module "nsg_management" {
  source = "../../modules/nsg"

  nsg_name            = "nsg-mgmt-${module.naming.base_name}"
  resource_group_name = module.resource_group.name
  location            = var.location
  subnet_id           = module.network.subnet_ids["management"]
  security_rules      = []
  tags                = module.naming.tags
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
    storage_queue = {
      name                 = "pe-${module.naming.base_name}-queue"
      target_resource_id   = module.storage.storage_account_id
      subresource_names    = ["queue"]
      private_dns_zone_ids = [module.private_dns.zone_ids["queue"]]
    }
    storage_table = {
      name                 = "pe-${module.naming.base_name}-table"
      target_resource_id   = module.storage.storage_account_id
      subresource_names    = ["table"]
      private_dns_zone_ids = [module.private_dns.zone_ids["table"]]
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
    iot_hub_private = {
      name               = "pe-${module.naming.base_name}-iothub"
      target_resource_id = module.iot_hub.id
      subresource_names  = ["iotHub"]
      private_dns_zone_ids = [
        module.private_dns.zone_ids["iot_hub"],
        module.private_dns.zone_ids["servicebus"]
      ]
    }
  }
}

module "iot_hub" {
  source = "../../modules/iot_hub"

  name                                            = module.naming.names.iot_hub
  resource_group_name                             = module.resource_group.name
  location                                        = var.iot_hub_location
  public_network_access_enabled                   = var.iot_hub_public_network_access_enabled
  local_authentication_enabled                    = var.iot_hub_local_authentication_enabled
  storage_container_name                          = module.storage.digital_twin_data_container_name
  storage_endpoint_uri                            = module.storage.blob_service_uri
  storage_account_resource_group_name             = module.resource_group.name
  storage_account_subscription_id                 = var.subscription_id
  enable_storage_endpoint                         = true
  enable_custom_eventhub_endpoint                 = false
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
  storage_queue_service_uri  = module.storage.queue_service_uri
  storage_table_service_uri  = module.storage.table_service_uri
  extra_app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING"     = module.observability_core.application_insights_connection_string
    "IotIngest"                                 = module.iot_hub.event_hub_compatible_connection_string
    "IotIngestEventHubName"                     = module.iot_hub.event_hub_events_path
    "IotIngestConsumerGroup"                    = var.iot_ingest_consumer_group_name
    "IotIngest__deviceTwinMap"                  = jsonencode(var.iot_device_twin_map)
    "AZURE_DIGITAL_TWINS_URL"                   = "https://${module.digital_twins.host_name}"
    "APPLICATIONINSIGHTS_AUTHENTICATION_STRING" = "Authorization=AAD"
  }
  tags = module.naming.tags

  depends_on = [
    module.private_dns,
    module.private_endpoints,
  ]
}

module "rbac" {
  source = "../../modules/rbac"

  role_assignments = merge(local.required_rbac_assignments, var.rbac_assignments)
}

module "iot_hub_routing" {
  source = "../../modules/iot_hub_routing"

  iothub_id                       = module.iot_hub.id
  iothub_name                     = module.iot_hub.name
  resource_group_name             = module.resource_group.name
  enable_storage_endpoint         = true
  storage_container_name          = module.storage.digital_twin_data_container_name
  storage_endpoint_uri            = module.storage.blob_service_uri
  storage_account_subscription_id = var.subscription_id
  events_consumer_group_name      = var.iot_ingest_consumer_group_name
  fallback_route_enabled          = false

  depends_on = [module.rbac]
}

module "diagnostic_settings" {
  source = "../../modules/diagnostic_settings"

  diagnostic_settings = {
    for k, v in local.diagnostic_targets : k => {
      target_resource_id         = v.target_resource_id
      log_analytics_workspace_id = module.observability_core.log_analytics_workspace_id
      name                       = "diag-${k}"
      log_category_groups        = k == "storage" || k == "storage_blob_service" ? [] : ["allLogs"]
      log_categories             = k == "storage_blob_service" ? ["StorageRead", "StorageWrite", "StorageDelete"] : []
      metric_categories          = k == "storage_blob_service" ? ["Transaction"] : ["AllMetrics"]
    }
  }
}

module "dashboard_workbook" {
  source = "../../modules/dashboard_workbook"

  resource_group_name        = module.resource_group.name
  location                   = var.location
  display_name               = "wb-${module.naming.base_name}-operations"
  log_analytics_workspace_id = module.observability_core.log_analytics_workspace_id
  iot_hub_id                 = module.iot_hub.id
  digital_twins_id           = module.digital_twins.id
  source_id                  = module.observability_core.log_analytics_workspace_id
  tags                       = module.naming.tags
}
