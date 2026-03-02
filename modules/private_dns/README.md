# Module: private_dns

## Purpose
Create Private DNS zones and link them to VNet(s).

## Inputs
- `resource_group_name` (string)
- `location` (string, usually `global` for zones)
- `zone_names` (list(string))
- `vnet_ids` (list(string))
- `tags` (map(string))

## Outputs
- `zone_ids` (map)
- `zone_names` (map)
- `vnet_link_ids` (map)

## Dependencies
- `network` module outputs (`vnet_id`).

## Out of Scope
- No private endpoints.
- No private DNS zone groups on endpoints.

## Security Notes
- Use least-privilege RBAC for zone management.
