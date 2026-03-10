resource "azurerm_digital_twins_instance" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azapi_update_resource" "dt_public_network_access" {
  type        = "Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31"
  resource_id = azurerm_digital_twins_instance.this.id
  body = { properties = {
    publicNetworkAccess = "Disabled"
  } }

}


