output "id" {
  description = "Network Security Group resource ID."
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "Network Security Group name."
  value       = azurerm_network_security_group.this.name
}

output "subnet_association_id" {
  description = "Subnet-NSG association resource ID."
  value       = azurerm_subnet_network_security_group_association.this.id
}

