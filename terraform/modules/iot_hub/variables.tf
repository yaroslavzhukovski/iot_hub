variable "name" {
  description = "IoT Hub name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{3,50}$", var.name))
    error_message = "name must be 3-50 chars using letters, numbers, and hyphens."
  }
}

variable "resource_group_name" {
  description = "Resource group name for IoT Hub."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for IoT Hub."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "sku_name" {
  description = "IoT Hub SKU name."
  type        = string
  default     = "S1"

  validation {
    condition     = contains(["F1", "B1", "S1", "S2", "S3"], upper(var.sku_name))
    error_message = "sku_name must be one of F1, B1, S1, S2, S3."
  }
}

variable "sku_capacity" {
  description = "IoT Hub capacity units."
  type        = number
  default     = 1

  validation {
    condition     = var.sku_capacity >= 1
    error_message = "sku_capacity must be >= 1."
  }
}

variable "local_authentication_enabled" {
  description = "Enable local auth (SAS/X.509). Keep true unless fully migrated to identity-only auth."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access for IoT Hub."
  type        = bool
  default     = true
}

variable "storage_endpoint_name" {
  description = "Name for IoT Hub storage routing endpoint."
  type        = string
  default     = "storage-export"
}

variable "enable_storage_endpoint" {
  description = "Whether to configure IoT Hub custom storage endpoint and storage route."
  type        = bool
  default     = true
}

variable "storage_account_resource_group_name" {
  description = "Resource group name of the target storage account used by IoT Hub routing."
  type        = string
}

variable "storage_account_subscription_id" {
  description = "Optional subscription ID of the target storage account. If null, current subscription is used."
  type        = string
  default     = null

  validation {
    condition     = var.storage_account_subscription_id == null || can(regex("^[0-9a-fA-F-]{36}$", var.storage_account_subscription_id))
    error_message = "storage_account_subscription_id must be null or a valid GUID."
  }
}

variable "storage_container_name" {
  description = "Storage container name for IoT Hub routing output."
  type        = string
}

variable "storage_endpoint_uri" {
  description = "Blob service endpoint URI of the target storage account (https://<account>.blob.core.windows.net)."
  type        = string
}

variable "storage_batch_frequency_in_seconds" {
  description = "Batch frequency for storage endpoint writes."
  type        = number
  default     = 60

  validation {
    condition     = var.storage_batch_frequency_in_seconds >= 60 && var.storage_batch_frequency_in_seconds <= 720
    error_message = "storage_batch_frequency_in_seconds must be between 60 and 720."
  }
}

variable "storage_max_chunk_size_in_bytes" {
  description = "Maximum chunk size for storage endpoint writes."
  type        = number
  default     = 10485760

  validation {
    condition     = var.storage_max_chunk_size_in_bytes > 0
    error_message = "storage_max_chunk_size_in_bytes must be > 0."
  }
}

variable "storage_encoding" {
  description = "Storage endpoint encoding."
  type        = string
  default     = "Avro"

  validation {
    condition     = contains(["Avro", "AvroDeflate", "JSON"], var.storage_encoding)
    error_message = "storage_encoding must be Avro, AvroDeflate, or JSON."
  }
}

variable "storage_file_name_format" {
  description = "File name format used for storage routing endpoint."
  type        = string
  default     = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
}

variable "storage_route_name" {
  description = "Route name for telemetry to storage endpoint."
  type        = string
  default     = "route-to-storage"
}

variable "storage_route_condition" {
  description = "Route condition for telemetry to storage endpoint."
  type        = string
  default     = "true"
}

variable "events_route_name" {
  description = "Route name for telemetry to built-in events endpoint."
  type        = string
  default     = "route-to-events"
}

variable "events_route_condition" {
  description = "Route condition for telemetry to built-in events endpoint."
  type        = string
  default     = "true"
}

variable "built_in_events_endpoint_name" {
  description = "Built-in endpoint name for event streaming."
  type        = string
  default     = "events"
}

variable "enable_custom_eventhub_endpoint" {
  description = "Whether to route events to a custom Event Hub endpoint instead of built-in events."
  type        = bool
  default     = false

  validation {
    condition = (
      !var.enable_custom_eventhub_endpoint ||
      (
        var.eventhub_resource_group_name != null &&
        var.eventhub_endpoint_uri != null &&
        var.eventhub_entity_path != null
      )
    )
    error_message = "When enable_custom_eventhub_endpoint is true, eventhub_resource_group_name, eventhub_endpoint_uri, and eventhub_entity_path must be set."
  }
}

variable "eventhub_endpoint_name" {
  description = "Name of IoT Hub custom Event Hub endpoint."
  type        = string
  default     = "eventhub-custom"
}

variable "eventhub_resource_group_name" {
  description = "Resource group of the Event Hubs namespace."
  type        = string
  default     = null
}

variable "eventhub_subscription_id" {
  description = "Optional subscription ID of Event Hubs namespace."
  type        = string
  default     = null
}

variable "eventhub_endpoint_uri" {
  description = "Event Hubs namespace endpoint URI (sb://...)."
  type        = string
  default     = null
}

variable "eventhub_entity_path" {
  description = "Event Hub name (entity path) inside namespace."
  type        = string
  default     = null
}

variable "fallback_route_enabled" {
  description = "Enable IoT Hub fallback route."
  type        = bool
  default     = false
}


variable "network_rule_default_action" {
  description = "Default action for IoT Hub network rule set."
  type        = string
  default     = "Deny"

  validation {
    condition     = contains(["Deny", "Allow"], var.network_rule_default_action)
    error_message = "network_rule_default_action must be Deny or Allow."
  }
}

variable "network_rule_apply_to_builtin_eventhub_endpoint" {
  description = "Whether network rules are also applied to the built-in Event Hub endpoint."
  type        = bool
  default     = false
}

variable "ip_rules" {
  description = "Optional allow IP rules (CIDR) for IoT Hub network rule set."
  type = list(object({
    name    = string
    ip_mask = string
    action  = optional(string, "Allow")
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.ip_rules :
      length(trimspace(r.name)) > 0 &&
      can(cidrnetmask(r.ip_mask)) &&
      lower(try(r.action, "Allow")) == "allow"
    ])
    error_message = "Each ip_rules entry must have non-empty name, valid CIDR ip_mask, and action Allow."
  }
}

variable "tags" {
  description = "Tags applied to IoT Hub."
  type        = map(string)
  default     = {}
}


