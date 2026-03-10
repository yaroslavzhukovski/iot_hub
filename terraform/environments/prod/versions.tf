terraform {
  required_version = ">= 1.14.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.62"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~>2.8"
    }
  }
}
