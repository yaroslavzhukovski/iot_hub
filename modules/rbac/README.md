# Module: rbac

## Purpose
Create RBAC role assignments for managed identities and service principals.

## Inputs
- `assignments` (map(object)): Principal ID, role definition, scope.

## Outputs
- `role_assignment_ids` (map)

## Dependencies
- Principal-producing modules (for example `function_flex`).
- Resource-producing modules (for scopes).

## Out of Scope
- No custom role definitions unless explicitly required.

## Security Notes
- Enforce least privilege and narrow scopes.
- Avoid broad subscription-level assignments by default.
