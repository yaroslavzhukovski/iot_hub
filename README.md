# Terraform Project Skeleton

Module-first layout with strict root composition.
Environment root should only call modules.

Current scope:
- Single environment: `environments/prod`.
- Private networking: `network`, `private_dns`, `private_endpoints`.
- Core services: `storage`, `key_vault`, `digital_twins`, `iot_hub`, `function_flex`.
- Security and identity: `rbac`.
- Observability: `observability_core`, `diagnostic_settings`.
- Shared standards: `naming`, `resource_group`.
