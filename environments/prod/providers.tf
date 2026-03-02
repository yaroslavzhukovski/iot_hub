provider "azurerm" {
  features {}

  subscription_id = var.subscription_id

  # Optional override; when null, provider may use authenticated context.
  tenant_id = var.tenant_id
}
