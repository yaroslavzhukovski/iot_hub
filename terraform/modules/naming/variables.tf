variable "project" {
  description = "Project or product identifier used in resource names."
  type        = string

  validation {
    condition     = length(trimspace(var.project)) >= 2
    error_message = "project must be at least 2 characters."
  }
}

variable "environment" {
  description = "Environment short name (for example: dev, stage, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "test", "qa", "stage", "prod"], lower(trimspace(var.environment)))
    error_message = "environment must be one of: dev, test, qa, stage, prod."
  }
}

variable "location" {
  description = "Azure location in canonical form (for example: swedencentral)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9 ]+$", trimspace(var.location)))
    error_message = "location must contain only letters, digits, and spaces."
  }
}

variable "instance" {
  description = "Instance discriminator for uniqueness (for example: 01)."
  type        = string
  default     = "01"

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{0,4}$", trimspace(var.instance)))
    error_message = "instance must be 0-4 alphanumeric characters."
  }
}

variable "global_suffix_length" {
  description = "Length of deterministic hash suffix for globally unique resource names. Set 0 to disable."
  type        = number
  default     = 5

  validation {
    condition     = var.global_suffix_length >= 0 && var.global_suffix_length <= 8
    error_message = "global_suffix_length must be between 0 and 8."
  }
}

variable "name_separator" {
  description = "Separator used for general resource names."
  type        = string
  default     = "-"

  validation {
    condition     = contains(["-", ""], var.name_separator)
    error_message = "name_separator must be '-' or ''."
  }
}

variable "region_short_overrides" {
  description = "Optional custom mapping from Azure location to short region code."
  type        = map(string)
  default     = {}
}

variable "additional_tags" {
  description = "Additional tags merged on top of standard tags."
  type        = map(string)
  default     = {}
}

variable "owner" {
  description = "Owning team or person tag."
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

  validation {
    condition     = contains(["public", "internal", "confidential", "restricted"], lower(trimspace(var.data_classification)))
    error_message = "data_classification must be one of: public, internal, confidential, restricted."
  }
}
