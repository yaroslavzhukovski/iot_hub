# Module: function_flex

## Purpose
Create Azure Function App on Flex Consumption with VNet integration and Managed Identity.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `name` (string)
- `service_plan` settings for Flex
- `storage_account` references for runtime requirements
- `subnet_id` (string) for VNet integration
- `app_settings` (map(string))
- `tags` (map(string))

## Outputs
- `id`
- `name`
- `principal_id`
- `default_hostname`

## Dependencies
- `network` module (`subnet_id`).
- `storage` module outputs.
- `observability_core` outputs (App Insights/Workspace links if used).

## Out of Scope
- No role assignments.
- No private endpoint creation in this module unless explicitly scoped.

## Security Notes
- Use identity-based connections only; avoid connection strings in code.
- Disable public access for inbound where officially supported.
