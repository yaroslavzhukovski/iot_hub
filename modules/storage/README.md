# Module: storage

## Purpose
Create Storage Account configured for secure private access patterns.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `name` (string)
- `account_tier` / `replication_type`
- `public_network_access_enabled` (bool)
- `allow_blob_public_access` (bool)
- `tags` (map(string))

## Outputs
- `id`
- `name`
- `primary_blob_endpoint`

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No private endpoint creation.
- No RBAC role assignments.

## Security Notes
- Enforce HTTPS only and minimum TLS.
- Keep public blob access disabled unless explicitly required.
