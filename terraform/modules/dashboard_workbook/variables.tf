variable "resource_group_name" {
  description = "Resource group where workbook is created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "display_name" {
  description = "Workbook display name."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace resource ID used by workbook queries."
  type        = string
}

variable "iot_hub_id" {
  description = "IoT Hub resource ID used by workbook queries."
  type        = string
}

variable "digital_twins_id" {
  description = "Azure Digital Twins resource ID used by workbook queries."
  type        = string
}

variable "category" {
  description = "Workbook category."
  type        = string
  default     = "workbook"
}

variable "source_id" {
  description = "Workbook source ID. Use Azure Monitor or a concrete resource ID."
  type        = string
  default     = "Azure Monitor"
}

variable "tags" {
  description = "Tags."
  type        = map(string)
  default     = {}
}
