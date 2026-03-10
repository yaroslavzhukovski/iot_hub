variable "storage_account_name" {
  description = "Name of the storage account to create."
  type        = string

  validation {
    condition     = length(trimspace(var.storage_account_name)) > 0 && can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "storage_account_name must be 3-24 characters, lowercase letters and numbers only."
  }

}

variable "resource_group_name" {
  description = "Name of the resource group where the storage account will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "location" {
  description = "Azure region where the storage account will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the storage account."
  type        = map(string)
  default     = {}
}

variable "enable_hierarchical_namespace" {
  description = "Whether to enable hierarchical namespace (Data Lake Storage Gen2) on the storage account."
  type        = bool
  default     = false
}

variable "account_tier" {
  description = "The performance tier of the storage account."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Premium"], var.account_tier)
    error_message = "account_tier must be either Standard or Premium."
  }
}

variable "replication_type" {
  description = "The replication strategy for the storage account."
  type        = string
  default     = "LRS"

  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.replication_type)
    error_message = "replication_type must be one of LRS, GRS, RAGRS, ZRS, GZRS, or RAGZRS."
  }
}

variable "enable_versioning" {
  description = "Whether to enable blob versioning on the storage account."
  type        = bool
  default     = true

}

variable "retention_days_soft_delete" {
  description = "Number of days to retain deleted blobs (soft delete)."
  type        = number
  default     = 7

  validation {
    condition     = var.retention_days_soft_delete >= 0 && var.retention_days_soft_delete <= 365
    error_message = "retention_days_soft_delete must be between 0 and 365."
  }
}

variable "functions_deploy_container_name" {
  description = "Name of the blob container for function deployments."
  type        = string
  default     = "function-deployments"

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])$", var.functions_deploy_container_name))
    error_message = "functions_deploy_container_name must be 3-63 chars, lowercase letters/numbers, and hyphens not at start or end."
  }
}

variable "digital_twin_data_container_name" {
  description = "Name of the blob container for digital twin data."
  type        = string
  default     = "digital-twin-data"

  validation {
    condition     = can(regex("^[a-z0-9](?:[a-z0-9-]{1,61}[a-z0-9])$", var.digital_twin_data_container_name))
    error_message = "digital_twin_data_container_name must be 3-63 chars, lowercase letters/numbers, and hyphens not at start or end."
  }

}
