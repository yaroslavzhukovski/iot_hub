# Global variables for this environment.

variable "subscription_id" {
  description = "Azure subscription ID for this environment."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id))
    error_message = "subscription_id must be a valid GUID."
  }
}

variable "tenant_id" {
  description = "Optional Azure Entra tenant ID override."
  type        = string
  default     = null

  validation {
    condition     = var.tenant_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "tenant_id must be null or a valid GUID."
  }
}

variable "project" {
  description = "Project identifier used in naming."
  type        = string
}

variable "environment" {
  description = "Environment identifier (for example: prod)."
  type        = string
}

variable "location" {
  description = "Primary Azure region for this environment."
  type        = string
}

variable "instance" {
  description = "Optional short instance discriminator for naming."
  type        = string
  default     = "01"
}

variable "global_suffix_length" {
  description = "Deterministic suffix length for globally scoped names."
  type        = number
  default     = 5
}

variable "region_short_overrides" {
  description = "Optional region short-code override map."
  type        = map(string)
  default     = {}
}

variable "owner" {
  description = "Owner tag value."
  type        = string
  default     = "platform"
}

variable "cost_center" {
  description = "Optional cost center tag value."
  type        = string
  default     = ""
}

variable "data_classification" {
  description = "Data classification tag value."
  type        = string
  default     = "internal"
}

variable "additional_tags" {
  description = "Additional tags merged on top of standard tags."
  type        = map(string)
  default     = {}
}

variable "network_address_space" {
  description = "VNet address space"
  type        = list(string)
  default     = ["10.10.0.0/16"]

  validation {
    condition     = length(var.network_address_space) > 0 && alltrue([for cidr in var.network_address_space : can(cidrnetmask(cidr))])
    error_message = "network_address_space must contain at least one valid CIDR block."
  }
}

variable "subnets" {
  description = "Lean subnet map for production baseline."
  type = map(object({
    name                              = string
    address_prefixes                  = list(string)
    private_endpoint_network_policies = optional(string, "Enabled")
    delegations = optional(list(object({
      name = string
      service_delegation = object({
        name = string
      })
    })), [])
  }))
  default = {
    function_integration = {
      name             = "function-integration"
      address_prefixes = ["10.10.10.0/24"]
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

  validation {
    condition = alltrue([
      for _, subnet in var.subnets :
      length(subnet.address_prefixes) > 0 &&
      alltrue([for cidr in subnet.address_prefixes : can(cidrnetmask(cidr))])
    ])
    error_message = "Each subnet must define at least one valid CIDR in address_prefixes."
  }
}

variable "flow_timeout_in_minutes" {
  description = "Flow timeout in minutes for the virtual network."
  type        = number
  default     = 30
}

variable "enable_vnet_encryption" {
  description = "Whether to enable encryption for the virtual network."
  type        = bool
  default     = false
}

variable "vnet_encryption_enforcement" {
  description = "Enforcement mode for virtual network encryption (if enabled)."
  type        = string
  default     = "DropUnencrypted"

  validation {
    condition     = contains(["AllowUnencrypted", "DropUnencrypted"], var.vnet_encryption_enforcement)
    error_message = "vnet_encryption_enforcement must be AllowUnencrypted or DropUnencrypted."
  }
}

variable "enable_network_telemetry" {
  description = "Enable AVM telemetry in network module."
  type        = bool
  default     = false
}

variable "key_vault_sku_name" {
  description = "SKU for Key Vault."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], lower(var.key_vault_sku_name))
    error_message = "key_vault_sku_name must be standard or premium."
  }
}

variable "key_vault_soft_delete_retention_days" {
  description = "Soft delete retention period for Key Vault."
  type        = number
  default     = 90

  validation {
    condition     = var.key_vault_soft_delete_retention_days >= 7 && var.key_vault_soft_delete_retention_days <= 90
    error_message = "key_vault_soft_delete_retention_days must be between 7 and 90."
  }
}

variable "key_vault_purge_protection_enabled" {
  description = "Whether purge protection is enabled for Key Vault."
  type        = bool
  default     = false
}

variable "digital_twins_location" {
  description = "Azure region for Azure Digital Twins."
  type        = string
  default     = "westeurope"

  validation {
    condition     = length(trimspace(var.digital_twins_location)) > 0
    error_message = "digital_twins_location must not be empty."
  }
}

variable "private_dns_zones" {
  description = "Map of private DNS zones to create, keyed by logical key."
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, z in var.private_dns_zones :
      length(trimspace(z.name)) > 0 && can(regex("^[A-Za-z0-9.-]+$", z.name))
    ])
    error_message = "Each private DNS zone must have a non-empty valid DNS zone name."
  }
}

variable "registration_enabled" {
  description = "Whether auto-registration is enabled on Private DNS zone links."
  type        = bool
  default     = false

}

variable "iot_hub_public_network_access_enabled" {
  description = "Enable public network access for IoT Hub."
  type        = bool
  default     = true
}

variable "iot_hub_local_authentication_enabled" {
  description = "Enable local authentication (SAS/X.509) for IoT Hub."
  type        = bool
  default     = true
}

variable "iot_hub_network_rule_default_action" {
  description = "Default action for IoT Hub network rule set."
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Deny", "Allow"], var.iot_hub_network_rule_default_action)
    error_message = "iot_hub_network_rule_default_action must be Deny or Allow."
  }
}

variable "iot_hub_network_rule_apply_to_builtin_eventhub_endpoint" {
  description = "Whether IoT Hub network rules apply to built-in events endpoint."
  type        = bool
  default     = false
}

variable "iot_hub_ip_rules" {
  description = "IP allow rules for IoT Hub network rule set."
  type = list(object({
    name    = string
    ip_mask = string
    action  = optional(string, "Allow")
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.iot_hub_ip_rules :
      length(trimspace(r.name)) > 0 &&
      can(cidrnetmask(r.ip_mask)) &&
      lower(try(r.action, "Allow")) == "allow"
    ])
    error_message = "Each iot_hub_ip_rules entry must have non-empty name, valid CIDR ip_mask, and action Allow."
  }
}

variable "eventhub_namespace_sku" {
  description = "Event Hubs namespace SKU."
  type        = string
  default     = "Standard"
}

variable "eventhub_namespace_capacity" {
  description = "Event Hubs namespace throughput units."
  type        = number
  default     = 1
}

variable "eventhub_partition_count" {
  description = "Partition count for ingestion Event Hub."
  type        = number
  default     = 2
}

variable "eventhub_message_retention" {
  description = "Retention days for ingestion Event Hub."
  type        = number
  default     = 1
}

variable "eventhub_public_network_access_enabled" {
  description = "Enable public network access for Event Hubs namespace."
  type        = bool
  default     = false
}

variable "eventhub_local_authentication_enabled" {
  description = "Enable local/SAS authentication for Event Hubs namespace."
  type        = bool
  default     = false
}

variable "eventhub_trusted_service_access_enabled" {
  description = "Allow trusted Microsoft services to bypass Event Hubs firewall."
  type        = bool
  default     = true
}
