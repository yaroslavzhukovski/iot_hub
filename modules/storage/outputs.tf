output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "blob_service_uri" {
  value = "https://${azurerm_storage_account.this.name}.blob.core.windows.net"
}

output "functions_deployment_container_url" {
  value = "https://${azurerm_storage_account.this.name}.blob.core.windows.net/${azurerm_storage_container.functions_deploy.name}"
}

output "processed_messages_container_name" {
  description = "Blob container name for processed messages written by Container App."
  value       = azurerm_storage_container.digital_twin_data.name
}
