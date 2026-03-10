# Module: iot_hub

## Purpose
Create IoT Hub with secure baseline configuration.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `name` (string)
- `sku_name` / `sku_capacity`
- `local_authentication_enabled` (bool)
- `public_network_access_enabled` (bool)
- `storage_endpoint_name` (string)
- `storage_account_resource_group_name` (string)
- `storage_account_subscription_id` (string, optional)
- `storage_container_name` (string)
- `storage_batch_frequency_in_seconds` (number)
- `storage_max_chunk_size_in_bytes` (number)
- `storage_encoding` (string)
- `storage_file_name_format` (string)
- `storage_route_name` / `storage_route_condition`
- `events_route_name` / `events_route_condition`
- `built_in_events_endpoint_name` (string, default `events`)
- `fallback_route_enabled` (bool)
- `tags` (map(string))

## Outputs
- `id`
- `name`
- `hostname`
- `identity_principal_id`
- `event_hub_events_endpoint`

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No device identities provisioning.
- No app/service credentials in module code.

## Security Notes
- Prefer Entra ID and RBAC for service-side access.
- Explicitly document regional limitation if Sweden Central is unavailable.
