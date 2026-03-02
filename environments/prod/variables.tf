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
