variable "vnet_name" {
  description = "Virtual Network name."
  type        = string

  validation {
    condition     = length(trimspace(var.vnet_name)) > 0
    error_message = "vnet_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for the Virtual Network."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "parent_id" {
  description = "Parent resource ID where the VNet is created (typically Resource Group ID)."
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+$", var.parent_id))
    error_message = "parent_id must be a valid Resource Group resource ID."
  }
}

variable "address_space" {
  description = "Address spaces for the Virtual Network."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0 && alltrue([for cidr in var.address_space : can(cidrnetmask(cidr))])
    error_message = "address_space must contain at least one valid CIDR block."
  }
}

variable "subnets" {
  description = "Lean subnet definitions for production baseline."
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
  default = {}

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
  description = "Flow timeout for VNet in minutes. Allowed range is 4..30."
  type        = number
  default     = null

  validation {
    condition     = var.flow_timeout_in_minutes == null || (var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30)
    error_message = "flow_timeout_in_minutes must be null or between 4 and 30."
  }
}

variable "enable_vnet_encryption" {
  description = "Enable VNet encryption."
  type        = bool
  default     = false
}

variable "vnet_encryption_enforcement" {
  description = "VNet encryption enforcement mode when encryption is enabled."
  type        = string
  default     = "DropUnencrypted"

  validation {
    condition     = contains(["AllowUnencrypted", "DropUnencrypted"], var.vnet_encryption_enforcement)
    error_message = "vnet_encryption_enforcement must be AllowUnencrypted or DropUnencrypted."
  }
}

variable "enable_telemetry" {
  description = "Enable telemetry for the AVM module."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags applied to the Virtual Network resources."
  type        = map(string)
  default     = {}
}
