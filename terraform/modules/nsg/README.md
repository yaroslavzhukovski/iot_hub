# Module: nsg

## Purpose
Create a Network Security Group and associate it to a subnet.

## Inputs
- `nsg_name` (string)
- `resource_group_name` (string)
- `location` (string)
- `subnet_id` (string)
- `security_rules` (list(object), optional)
- `tags` (map(string), optional)

## Outputs
- `id`
- `name`
- `subnet_association_id`

## Notes
- Keep rules minimal at first, then tighten based on observed traffic and diagnostics.

