variable "namespace_name" {
  description = "Event Hubs namespace name."
  type        = string
}

variable "eventhub_name" {
  description = "Event Hub name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "namespace_sku" {
  description = "Event Hubs namespace SKU."
  type        = string
  default     = "Standard"
}

variable "namespace_capacity" {
  description = "Throughput units for namespace."
  type        = number
  default     = 1
}

variable "partition_count" {
  description = "Event Hub partition count."
  type        = number
  default     = 2
}

variable "message_retention" {
  description = "Event retention in days."
  type        = number
  default     = 1
}

variable "public_network_access_enabled" {
  description = "Enable public network access for Event Hubs namespace."
  type        = bool
  default     = false
}

variable "local_authentication_enabled" {
  description = "Enable SAS local auth for Event Hubs namespace."
  type        = bool
  default     = false
}

variable "network_rules_default_action" {
  description = "Default action for Event Hubs namespace firewall."
  type        = string
  default     = "Deny"
}

variable "trusted_service_access_enabled" {
  description = "Allow trusted Microsoft services to bypass Event Hubs firewall."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
