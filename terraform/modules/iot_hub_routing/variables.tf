variable "iothub_id" {
  description = "IoT Hub resource ID."
  type        = string
}

variable "iothub_name" {
  description = "IoT Hub name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name of the IoT Hub."
  type        = string
}

variable "enable_storage_endpoint" {
  description = "Whether to configure IoT Hub storage endpoint and storage route."
  type        = bool
  default     = true
}

variable "storage_endpoint_name" {
  description = "Name for IoT Hub storage routing endpoint."
  type        = string
  default     = "storage-export"
}

variable "storage_account_subscription_id" {
  description = "Optional subscription ID of the target storage account. If null, current subscription is used."
  type        = string
  default     = null
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
}

variable "storage_max_chunk_size_in_bytes" {
  description = "Maximum chunk size for storage endpoint writes."
  type        = number
  default     = 10485760
}

variable "storage_encoding" {
  description = "Storage endpoint encoding."
  type        = string
  default     = "Avro"
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

variable "enable_events_consumer_group" {
  description = "Whether to create a dedicated consumer group on the built-in events endpoint."
  type        = bool
  default     = true
}

variable "events_consumer_group_name" {
  description = "Name of the dedicated consumer group for Function ingestion."
  type        = string
  default     = "func-ingest"

  validation {
    condition     = length(trimspace(var.events_consumer_group_name)) > 0 && !startswith(var.events_consumer_group_name, "$")
    error_message = "events_consumer_group_name must not be empty and must not start with '$' (reserved names)."
  }
}

variable "built_in_events_endpoint_name" {
  description = "Built-in endpoint name for event streaming."
  type        = string
  default     = "events"
}

variable "fallback_route_enabled" {
  description = "Enable IoT Hub fallback route."
  type        = bool
  default     = false
}
