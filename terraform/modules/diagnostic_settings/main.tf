resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                       = coalesce(try(each.value.name, null), "diag-${substr(md5(each.key), 0, 8)}")
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id
  log_analytics_destination_type = try(each.value.log_analytics_destination_type, "Dedicated")

  dynamic "enabled_log" {
    for_each = try(each.value.log_categories, [])
    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_log" {
    for_each = try(each.value.log_category_groups, [])
    content {
      category_group = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = try(each.value.metric_categories, [])
    content {
      category = enabled_metric.value
    }
  }
}
