# Module: network

## Purpose
Create VNet and required subnets for Function integration and Private Endpoints.

## Inputs
- `parent_id` (string): Parent Resource Group resource ID.
- `location` (string)
- `vnet_name` (string)
- `address_space` (list(string))
- `subnets` (map(any)): Passed through to AVM virtual network module subnet schema.
- `flow_timeout_in_minutes` (number, optional)
- `enable_vnet_encryption` (bool)
- `vnet_encryption_enforcement` (string): `AllowUnencrypted|DropUnencrypted`
- `enable_telemetry` (bool)
- `tags` (map(string))

## Outputs
- `vnet_id`
- `vnet_name`
- `subnet_ids` (map)
- `subnet_names` (map)

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No private DNS zones.
- No private endpoints.
- No diagnostic settings (attach via dedicated `diagnostic_settings` module).

## Security Notes
- Keep dedicated subnet for private endpoints.
- Enforce NSG/UDR strategy outside or inside this module consistently.
