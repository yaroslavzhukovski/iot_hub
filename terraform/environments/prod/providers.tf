provider "azurerm" {
  features {}

  subscription_id     = var.subscription_id
  storage_use_azuread = true

  # Optional override; when null, provider may use authenticated context.
  tenant_id = var.tenant_id
}

provider "azapi" {

}
