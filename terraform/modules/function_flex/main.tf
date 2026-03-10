resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location

  os_type  = "Linux"
  sku_name = "FC1"

  tags = var.tags
}

resource "azurerm_function_app_flex_consumption" "this" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id = azurerm_service_plan.this.id

  https_only                    = true
  public_network_access_enabled = false

  virtual_network_subnet_id = var.subnet_id

  webdeploy_publish_basic_authentication_enabled = false

  identity {
    type = "SystemAssigned"
  }

  # Flex deployment storage (code package container) with Managed Identity
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = var.storage_container_endpoint
  storage_authentication_type = "SystemAssignedIdentity"

  # Runtime for Flex
  runtime_name    = "python"
  runtime_version = "3.12"

  site_config {
    minimum_tls_version = "1.2"
  }

  app_settings = merge(
    {
      # Storage settings for Functions runtime (required for Flex)
      "AzureWebJobsStorage__credential"     = "managedidentity"
      "AzureWebJobsStorage__blobServiceUri" = var.storage_blob_service_uri
      "AzureWebJobsStorage__queueServiceUri" = var.storage_queue_service_uri
      "AzureWebJobsStorage__tableServiceUri" = var.storage_table_service_uri
    },
    var.extra_app_settings
  )

  tags = var.tags
}
