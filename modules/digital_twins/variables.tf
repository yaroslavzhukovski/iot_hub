variable "name" {
  description = "Name of the Digital Twins instance."
  type        = string
  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9-]{1,62}[A-Za-z0-9]$", var.name))
    error_message = "name must be 3-64 chars, alphanumeric or '-', and start/end with alphanumeric."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where the Digital Twins instance will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Location of the Digital Twins instance."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "tags" {
  description = "Tags to be applied to the Digital Twins instance."
  type        = map(string)
  default     = {}
}
