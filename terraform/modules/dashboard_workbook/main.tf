locals {
  # Stable GUID-like workbook name based on display name.
  workbook_name = uuidv5("6ba7b810-9dad-11d1-80b4-00c04fd430c8", var.display_name)

  workbook_data = {
    version = "Notebook/1.0"
    items = [
      {
        type = 1
        name = "intro"
        content = {
          json = "# IoT Platform Health\nThis workbook shows basic ingestion and error signals from Log Analytics."
        }
      },
      {
        type = 3
        name = "iot-hub-messages"
        content = {
          version = "KqlItem/1.0"
          title   = "IoT Hub: message traffic (last 24h)"
          query   = "AzureMetrics | where TimeGenerated > ago(24h) | where _ResourceId =~ '${lower(var.iot_hub_id)}' | summarize Value=sumif(Total, isnotnull(Total)), Samples=count() by MetricName, bin(TimeGenerated, 15m) | extend Count=coalesce(Value, todouble(Samples)) | summarize Count=sum(Count) by bin(TimeGenerated, 15m) | order by TimeGenerated asc"
          queryType = 0
          resourceType = "microsoft.operationalinsights/workspaces"
          crossComponentResources = [var.log_analytics_workspace_id]
          visualization = "timechart"
          size = 0
          timeContext = {
            durationMs = 86400000
          }
        }
      },
      {
        type = 3
        name = "function-errors"
        content = {
          version = "KqlItem/1.0"
          title   = "Function errors (last 24h)"
          query   = "union isfuzzy=true (AppTraces | project TimeGenerated, Severity=tostring(SeverityLevel), Message=tostring(Message)), (FunctionAppLogs | project TimeGenerated, Severity=tostring(Level), Message=tostring(Message)) | where TimeGenerated > ago(24h) | where Severity in ('3', '4', 'Error', 'Critical') or Message has_cs 'Exception' or Message has_cs 'Failed' or Message has 'error' | summarize Errors=count() by bin(TimeGenerated, 15m) | order by TimeGenerated asc"
          queryType = 0
          resourceType = "microsoft.operationalinsights/workspaces"
          crossComponentResources = [var.log_analytics_workspace_id]
          visualization = "timechart"
          size = 0
          timeContext = {
            durationMs = 86400000
          }
        }
      },
      {
        type = 3
        name = "digital-twins-events"
        content = {
          version = "KqlItem/1.0"
          title   = "Digital Twins diagnostics (last 24h)"
          query   = "union isfuzzy=true (ADTDigitalTwinsOperation), (ADTEventRoutesOperation), (ADTModelsOperation), (ADTQueryOperation) | where TimeGenerated > ago(24h) | where _ResourceId =~ '${lower(var.digital_twins_id)}' | summarize Count=count() by bin(TimeGenerated, 15m) | order by TimeGenerated asc"
          queryType = 0
          resourceType = "microsoft.operationalinsights/workspaces"
          crossComponentResources = [var.log_analytics_workspace_id]
          visualization = "timechart"
          size = 0
          timeContext = {
            durationMs = 86400000
          }
        }
      }
    ]
    isLocked = false
  }
}

resource "azurerm_application_insights_workbook" "this" {
  name                = local.workbook_name
  resource_group_name = var.resource_group_name
  location            = var.location
  display_name        = var.display_name
  category            = var.category
  source_id           = lower(var.source_id)
  data_json           = jsonencode(local.workbook_data)
  tags                = var.tags
}
