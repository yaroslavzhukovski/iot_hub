output "role_assignment_ids" {
  description = "Role assignment resource IDs keyed by assignment key."
  value       = { for k, v in azurerm_role_assignment.this : k => v.id }
}
