# Module: private_dns

## Purpose
Create Private DNS zones and link them to VNet(s).

## Inputs
- `resource_group_name` (string)
- `private_dns_zones` (map(object)): Zone definitions keyed by logical key (`name`, optional `tags`)
- `vnet_ids` (map(string)): VNet IDs keyed by logical VNet key
- `registration_enabled` (bool, default `false`)
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
