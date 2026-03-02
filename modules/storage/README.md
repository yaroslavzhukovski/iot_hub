# Module: storage

## Purpose
Create Storage Account configured for secure private access patterns.

## Inputs
- `resource_group_name` (string)
- `location` (string)
- `storage_account_name` (string)
- `account_tier` / `replication_type`
- `enable_hierarchical_namespace` (bool)
- `enable_versioning` (bool)
- `retention_days_soft_delete` (number)
- `functions_deploy_container_name` (string)
- `digital_twin_data_container_name` (string)
- `tags` (map(string))

## Outputs
- `storage_account_id`
- `storage_account_name`
- `blob_service_uri`
- `functions_deployment_container_url`
- `processed_messages_container_name`

## Dependencies
- `resource_group` module outputs.

## Out of Scope
- No private endpoint creation.
- No RBAC role assignments.

## Security Notes
- Enforce HTTPS only and minimum TLS.
- Keep public blob access disabled unless explicitly required.
- Avoid key/connection-string outputs; use Managed Identity and RBAC.
