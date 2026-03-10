variable "resource_group_name" {
  description = "Resource group for observability resources."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "Log Analytics workspace name."
  type        = string
}

variable "application_insights_name" {
  description = "Application Insights name."
  type        = string
}

variable "log_analytics_retention_in_days" {
  description = "Retention for Log Analytics workspace."
  type        = number
  default     = 30
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily ingestion quota in GB for Log Analytics (-1 for unlimited)."
  type        = number
  default     = 1
}

variable "application_insights_daily_data_cap_in_gb" {
  description = "Daily data cap in GB for Application Insights."
  type        = number
  default     = 1
}

variable "application_insights_sampling_percentage" {
  description = "Sampling percentage for Application Insights."
  type        = number
  default     = 25
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
