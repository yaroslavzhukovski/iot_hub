variable "private_dns_zones" {
  description = "Map of private DNS zones to create, keyed by logical key."
  type = map(object({
    name = string
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for _, z in var.private_dns_zones :
      length(trimspace(z.name)) > 0 && can(regex("^[A-Za-z0-9.-]+$", z.name))
    ])
    error_message = "Each private DNS zone must have a non-empty valid DNS zone name."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where private DNS zones are created."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "vnet_ids" {
  description = "Map of VNet IDs keyed by logical VNet key (for stable for_each keys)."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for _, id in var.vnet_ids : length(trimspace(id)) > 0])
    error_message = "Each vnet_ids value must be a non-empty VNet resource ID."
  }
}

variable "registration_enabled" {
  description = "Whether auto-registration is enabled on zone links (typically false for Private DNS zones)."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to all private DNS zones."
  type        = map(string)
  default     = {}
}
