variable "private_endpoints" {
  description = "Map of private endpoints to create, keyed by logical key."
  type = map(object({
    name                 = string
    target_resource_id   = string
    subresource_names    = list(string)
    private_dns_zone_ids = list(string)
    tags                 = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for _, pe in var.private_endpoints :
      length(trimspace(pe.name)) > 0 &&
      can(regex("^[A-Za-z0-9-]+$", pe.name)) &&
      can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/[^/]+/.+$", trimspace(pe.target_resource_id))) &&
      length(pe.subresource_names) > 0 &&
      alltrue([for s in pe.subresource_names : length(trimspace(s)) > 0]) &&
      length(pe.private_dns_zone_ids) > 0 &&
      alltrue([
        for id in pe.private_dns_zone_ids :
        can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Network/privateDnsZones/[^/]+$", trimspace(id)))
      ])
    ])
    error_message = "Each private endpoint requires valid Azure IDs for target_resource_id and private_dns_zone_ids, plus non-empty name and subresource_names."
  }

  validation {
    condition     = length(distinct([for _, pe in var.private_endpoints : lower(trimspace(pe.name))])) == length(var.private_endpoints)
    error_message = "Private endpoint names must be unique (case-insensitive)."
  }

}
variable "location" {
  description = "Azure region for the private endpoints."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }

}

variable "resource_group_name" {
  description = "Name of the resource group where private endpoints are created."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }

}

variable "subnet_id" {
  description = "Resource ID of the subnet where private endpoints will be placed."
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Network/virtualNetworks/[^/]+/subnets/[^/]+$", trimspace(var.subnet_id)))
    error_message = "subnet_id must be a valid subnet resource ID."
  }

}

variable "private_dns_zone_group_name" {
  description = "Name of the private DNS zone group for the private endpoint."
  type        = string
  default     = "default-dns-zone-group"

  validation {
    condition     = length(trimspace(var.private_dns_zone_group_name)) > 0
    error_message = "private_dns_zone_group_name must not be empty."
  }

}

variable "tags" {
  description = "Default tags applied to all private endpoints."
  type        = map(string)
  default     = {}
}
