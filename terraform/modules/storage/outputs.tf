output "storage_account_id" {
  description = "The ID of the Storage Account."
  value       = azurerm_storage_account.this.id
}

output "storage_account_name" {
  description = "The name of the Storage Account."
  value       = azurerm_storage_account.this.name
}

output "blob_service_uri" {
  description = "Blob service endpoint URI without trailing slash."
  value       = trimsuffix(azurerm_storage_account.this.primary_blob_endpoint, "/")
}

output "queue_service_uri" {
  description = "Queue service endpoint URI without trailing slash."
  value       = trimsuffix(azurerm_storage_account.this.primary_queue_endpoint, "/")
}

output "table_service_uri" {
  description = "Table service endpoint URI without trailing slash."
  value       = trimsuffix(azurerm_storage_account.this.primary_table_endpoint, "/")
}

output "functions_deployment_container_url" {
  description = "Blob container URL for function deployment package source."
  value       = "${trimsuffix(azurerm_storage_account.this.primary_blob_endpoint, "/")}/${azurerm_storage_container.functions_deploy.name}"
}

output "digital_twin_data_container_name" {
  description = "Blob container name for digital twin data."
  value       = azurerm_storage_container.digital_twin_data.name
}

