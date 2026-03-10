# Module: key_vault

## Purpose
Create Key Vault in RBAC mode for secret access via Managed Identity.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `key_vault_name` (string)
- `tenant_id` (string)
- `sku_name` (string)
- `soft_delete_retention_days` (number)
- `purge_protection_enabled` (bool)
- `tags` (map(string))

## Outputs
- `id`
- `name`
- `vault_uri`

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No legacy access policies.
- No secret values should be provisioned here unless explicitly needed.

## Security Notes
- Prefer private endpoint + private DNS.
- Keep purge protection/soft delete aligned with policy.
- RBAC mode is enforced and public network access is disabled by default in module code.
