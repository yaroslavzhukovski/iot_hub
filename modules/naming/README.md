# Module: naming

## Purpose
Centralize naming and standard tags to keep resources consistent across modules.

## Inputs
- `project` (string): Project identifier.
- `environment` (string): Environment name (for example `prod`).
- `region` (string): Azure region code.
- `custom_tags` (map(string)): Extra tags to merge with defaults.

## Outputs
- `name_prefix`: Base naming prefix.
- `region_short`: Region short code.
- `tags`: Final merged tags map.

## Dependencies
- None.

## Out of Scope
- No Azure resources created in this module.

## Security Notes
- Avoid embedding sensitive values in tags.
