variable "diagnostic_settings" {
  description = "Map of diagnostic settings keyed by logical key."
  type = map(object({
    target_resource_id             = string
    log_analytics_workspace_id     = string
    name                           = optional(string)
    log_categories                 = optional(set(string), [])
    log_category_groups            = optional(set(string), ["allLogs"])
    metric_categories              = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type = optional(string, "Dedicated")
  }))
  default = {}
}
