# Committed non-secret environment values for prod.

# Naming and environment context
project     = "iot"
environment = "prod"
location    = "Sweden Central"
instance    = "01"

# Optional naming controls
global_suffix_length = 5

# Optional governance tags
owner               = "platform"
data_classification = "internal"
additional_tags = {
  workload = "iot-hub"
}

# Network
network_address_space = ["10.10.0.0/16"]
subnets = {
  function_integration = {
    name             = "function-integration"
    address_prefixes = ["10.10.10.0/24"]
    delegations = [{
      name = "func-flex-delegation"
      service_delegation = {
        name = "Microsoft.App/environments"
      }
    }]
  }
  private_endpoints = {
    name                              = "private-endpoints"
    address_prefixes                  = ["10.10.20.0/24"]
    private_endpoint_network_policies = "Disabled"
  }
  management = {
    name             = "management"
    address_prefixes = ["10.10.30.0/24"]
  }
}
flow_timeout_in_minutes     = 30
enable_vnet_encryption      = false
vnet_encryption_enforcement = "DropUnencrypted"
enable_network_telemetry    = false

# Key Vault
key_vault_sku_name                   = "standard"
key_vault_soft_delete_retention_days = 90
key_vault_purge_protection_enabled   = false

# Digital Twins
digital_twins_location = "westeurope"

# IoT Hub
iot_hub_location = "westeurope"

# Private DNS
private_dns_zones = {
  blob = {
    name = "privatelink.blob.core.windows.net"
  }
  queue = {
    name = "privatelink.queue.core.windows.net"
  }
  table = {
    name = "privatelink.table.core.windows.net"
  }
  key_vault = {
    name = "privatelink.vaultcore.azure.net"
  }
  iot_hub = {
    name = "privatelink.azure-devices.net"
  }
  digital_twins = {
    name = "privatelink.digitaltwins.azure.net"
  }
  servicebus = {
    name = "privatelink.servicebus.windows.net"
  }
}

# IoT Hub network security
iot_hub_public_network_access_enabled                   = true
iot_hub_local_authentication_enabled                    = true
iot_hub_network_rule_default_action                     = "Deny"
iot_hub_network_rule_apply_to_builtin_eventhub_endpoint = true
iot_ingest_consumer_group_name                          = "func-ingest"
iot_device_twin_map = {
  thermostat1 = "thermostat-101"
}
iot_hub_ip_rules = [
  {
    name    = "allow-my-ip"
    ip_mask = "89.253.122.125/32"
    action  = "Allow"
  }
]

# Observability
log_analytics_retention_in_days           = 30
log_analytics_daily_quota_gb              = 1
application_insights_daily_data_cap_in_gb = 1
application_insights_sampling_percentage  = 25
