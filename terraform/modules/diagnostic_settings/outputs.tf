output "diagnostic_setting_ids" {
  description = "Diagnostic setting IDs keyed by logical key."
  value       = { for k, v in azurerm_monitor_diagnostic_setting.this : k => v.id }
}
