# Module: private_endpoints

## Purpose
Create reusable Private Endpoints and associate them with Private DNS zones.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `subnet_id` (string)
- `private_endpoints` (map(object)): Endpoint name, target resource ID, subresource names, DNS zone IDs, optional tags.
- `private_dns_zone_group_name` (string)
- `tags` (map(string))

## Outputs
- `private_endpoint_ids` (map)
- `private_ip_addresses` (map)
- `network_interface_ids` (map)

## Dependencies
- `network` module (`subnet_id`).
- `private_dns` module (`zone_ids`).
- Target resource modules (Storage, Key Vault, ADT).

## Out of Scope
- No Private DNS zone creation.
- No target resource creation.

## Security Notes
- Disable public network access on target resources where officially supported.
