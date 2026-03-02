# Module: network

## Purpose
Create VNet and required subnets for Function integration and Private Endpoints.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `vnet_name` (string)
- `address_space` (list(string))
- `subnets` (map(object)): Subnet names, CIDRs, and policy flags.
- `tags` (map(string))

## Outputs
- `vnet_id`
- `vnet_name`
- `subnet_ids` (map)

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No private DNS zones.
- No private endpoints.

## Security Notes
- Keep dedicated subnet for private endpoints.
- Enforce NSG/UDR strategy outside or inside this module consistently.
