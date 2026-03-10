variable "key_vault_name" {
  description = "Name of the Key Vault instance."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{1,22}[a-zA-Z0-9]$", var.key_vault_name))
    error_message = "key_vault_name must be 3-24 chars, alphanumeric or '-', and start/end with alphanumeric."
  }
}

variable "location" {
  description = "Azure region for the Key Vault instance."
  type        = string

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group where the Key Vault will be created."
  type        = string

  validation {
    condition     = length(trimspace(var.resource_group_name)) > 0
    error_message = "resource_group_name must not be empty."
  }
}

variable "tags" {
  description = "A map of tags to assign to the Key Vault."
  type        = map(string)
  default     = {}
}

variable "sku_name" {
  description = "The SKU name of the Key Vault. E.g., 'standard' or 'premium'."
  type        = string
  default     = "standard"

  validation {
    condition     = contains(["standard", "premium"], lower(var.sku_name))
    error_message = "sku_name must be either 'standard' or 'premium'."
  }
}

variable "tenant_id" {
  description = "The Microsoft Entra tenant ID for Key Vault."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "tenant_id must be a valid GUID."
  }
}

variable "soft_delete_retention_days" {
  description = "Number of days to retain deleted Key Vaults (soft delete)."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "soft_delete_retention_days must be between 7 and 90."
  }

}

variable "purge_protection_enabled" {
  description = "Whether to enable purge protection on the Key Vault."
  type        = bool
  default     = false
}
