output "function_app_id" {
  value = azurerm_function_app_flex_consumption.this.id
}

output "function_app_principal_id" {
  value = azurerm_function_app_flex_consumption.this.identity[0].principal_id
}

output "service_plan_id" {
  value = azurerm_service_plan.this.id
}

output "function_app_name" {
  value = azurerm_function_app_flex_consumption.this.name
}

output "function_app_default_hostname" {
  value = azurerm_function_app_flex_consumption.this.default_hostname
}
