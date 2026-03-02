# Module: diagnostic_settings

## Purpose
Attach diagnostic settings from target resources to Log Analytics.

## Inputs
- `targets` (map(object)): Resource IDs and enabled log/metric categories.
- `log_analytics_workspace_id` (string)
- `diagnostic_settings_name_prefix` (string)

## Outputs
- `diagnostic_setting_ids` (map)

## Dependencies
- `observability_core` (`log_analytics_workspace_id`).
- Any module exposing target `resource_id`.

## Out of Scope
- No creation of Log Analytics or App Insights.

## Security Notes
- Enable only required categories to reduce exposure and cost.
