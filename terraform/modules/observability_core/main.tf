resource "azurerm_log_analytics_workspace" "this" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_analytics_retention_in_days
  daily_quota_gb      = var.log_analytics_daily_quota_gb
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  name                = var.application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"

  # Explicit workspace binding avoids any default auto-created workspace behavior.
  workspace_id = azurerm_log_analytics_workspace.this.id

  local_authentication_disabled    = true
  internet_ingestion_enabled       = true
  internet_query_enabled           = true
  daily_data_cap_in_gb             = var.application_insights_daily_data_cap_in_gb
  sampling_percentage              = var.application_insights_sampling_percentage
  daily_data_cap_notifications_disabled = false
  tags                             = var.tags
}
