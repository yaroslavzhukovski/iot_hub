variable "service_plan_name" {
  type        = string
  description = "Name of the Service Plan for the Function App Flex Consumption."
}

variable "function_app_name" {
  type        = string
  description = "Name of the Function App Flex Consumption."
}
variable "storage_container_endpoint" {
  type        = string
  description = "The endpoint of the storage container for the Function App Flex Consumption code package."
}

variable "storage_blob_service_uri" {
  type        = string
  description = "The blob service URI of the storage account used by the Function App Flex Consumption runtime."
}

variable "storage_queue_service_uri" {
  type        = string
  description = "The queue service URI of the storage account used by the Function App Flex Consumption runtime."
}

variable "storage_table_service_uri" {
  type        = string
  description = "The table service URI of the storage account used by the Function App Flex Consumption runtime."
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID used for VNet integration."
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to resources."
  default     = {}
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "extra_app_settings" {
  type        = map(string)
  description = "Additional app settings for project-specific integrations."
  default     = {}
}
