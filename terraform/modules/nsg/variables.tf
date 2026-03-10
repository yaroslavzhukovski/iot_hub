variable "nsg_name" {
  description = "Network Security Group name."
  type        = string

  validation {
    condition     = length(trimspace(var.nsg_name)) > 0
    error_message = "nsg_name must not be empty."
  }
}

variable "resource_group_name" {
  description = "Resource Group name where NSG is created."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region for NSG."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "subnet_id" {
  description = "Subnet resource ID to associate NSG with."
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft\\.Network/virtualNetworks/[^/]+/subnets/[^/]+$", var.subnet_id))
    error_message = "subnet_id must be a valid subnet resource ID."
  }
}

variable "security_rules" {
  description = "Optional list of NSG security rules."
  type = list(object({
    name                       = string
    description                = optional(string)
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.security_rules :
      r.priority >= 100 && r.priority <= 4096 &&
      contains(["Inbound", "Outbound"], r.direction) &&
      contains(["Allow", "Deny"], r.access) &&
      contains(["Tcp", "Udp", "*"], r.protocol)
    ])
    error_message = "Each security rule must have priority 100-4096, valid direction/access, and protocol Tcp/Udp/*."
  }
}

variable "tags" {
  description = "Tags applied to NSG."
  type        = map(string)
  default     = {}
}

