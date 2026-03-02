# Module: iot_hub

## Purpose
Create IoT Hub with secure baseline configuration.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `name` (string)
- `sku_name` / `capacity`
- `local_authentication_enabled` (bool, if supported)
- `public_network_access_enabled` (bool, if supported)
- `tags` (map(string))

## Outputs
- `id`
- `name`
- `hostname`

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No consumer groups/routes unless explicitly required.
- No app/service credentials in module code.

## Security Notes
- Prefer Entra ID and RBAC for service-side access.
- Explicitly document regional limitation if Sweden Central is unavailable.
