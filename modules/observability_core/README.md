# Module: observability_core

## Purpose
Create shared monitoring primitives: Log Analytics Workspace and Application Insights.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `workspace_name` (string)
- `workspace_retention_in_days` (number)
- `app_insights_name` (string)
- `tags` (map(string))

## Outputs
- `log_analytics_workspace_id`
- `application_insights_id`
- `application_insights_connection_string` (if needed by platform config)

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No diagnostic settings attachments to other resources.

## Security Notes
- Keep retention minimal for cost while meeting compliance.
- Avoid sending sensitive payloads in telemetry.
