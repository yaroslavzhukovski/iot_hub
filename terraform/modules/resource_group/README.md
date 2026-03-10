# Module: resource_group

## Purpose
Create and manage the target Resource Group for this environment.

## Inputs
- `name` (string): Resource Group name.
- `location` (string): Azure region.
- `tags` (map(string)): Standard tags.

## Outputs
- `id`: Resource Group ID.
- `name`: Resource Group name.
- `location`: Resource Group location.

## Dependencies
- None.

## Out of Scope
- No child resources should be created here.

## Security Notes
- Use resource locks and RBAC outside this module when needed.
