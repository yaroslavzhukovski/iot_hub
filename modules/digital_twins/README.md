# Module: digital_twins

## Purpose
Create Azure Digital Twins instance in a supported region.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `name` (string)
- `identity_type` (string)
- `public_network_access_enabled` (bool, if supported by API/provider)
- `tags` (map(string))

## Outputs
- `id`
- `name`
- `host_name`

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No graph models/twins data provisioning.
- No private endpoint creation.

## Security Notes
- Use Managed Identity/RBAC access from callers.
- Document regional exception if not available in Sweden Central.
