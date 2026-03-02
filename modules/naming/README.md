# Module: naming

## Purpose
Generate consistent production-grade names and tags for all modules.

## Inputs
- `project` (string): Project identifier.
- `environment` (string): Environment (`dev|test|qa|stage|prod`).
- `location` (string): Azure location (for example `swedencentral` or `Sweden Central`).
- `instance` (string): Optional short uniqueness suffix (default `01`, can be empty).
- `name_separator` (string): `-` or empty string.
- `global_suffix_length` (number): Deterministic hash suffix length for global namespaces (`0..8`, default `5`).
- `region_short_overrides` (map(string)): Optional region short-code overrides.
- `owner` (string): Owner tag.
- `cost_center` (string): Optional cost center tag.
- `data_classification` (string): `public|internal|confidential|restricted`.
- `additional_tags` (map(string)): Extra tags merged last.

## Outputs
- `base_name`: Canonical base name.
- `region_short`: Short region code.
- `tags`: Standardized tags map.
- `names`: Standardized names map (rg, vnet, storage, kv, func, iothub, adt, appi, law, subnets).

## Dependencies
- None.

## Out of Scope
- No Azure resources are created.
- Absolute uniqueness is not guaranteed if naming inputs are duplicated intentionally across deployments.

## Security Notes
- Never include secrets in tags or names.
- Keep naming deterministic to simplify auditing and incident response.
