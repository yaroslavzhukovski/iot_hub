# Outputs for module 'digital_twins'.
# Export IDs and values needed by root or other modules.
output "id" {
  description = "The ID of the Digital Twins instance."
  value       = azurerm_digital_twins_instance.this.id

}

output "name" {
  description = "The name of the Digital Twins instance."
  value       = azurerm_digital_twins_instance.this.name

}

output "identity_principal_id" {
  description = "The principal ID of the identity assigned to the Digital Twins instance."
  value       = azurerm_digital_twins_instance.this.identity[0].principal_id

}

output "host_name" {
  description = "The host name of the Digital Twins instance."
  value       = azurerm_digital_twins_instance.this.host_name
}
