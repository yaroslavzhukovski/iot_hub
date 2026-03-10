variable "role_assignments" {
  description = "Map of role assignments keyed by logical assignment key."
  type = map(object({
    scope                = string
    principal_id         = string
    role_definition_name = string
    principal_type       = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for _, a in var.role_assignments :
      length(trimspace(a.scope)) > 0 &&
      length(trimspace(a.principal_id)) > 0 &&
      length(trimspace(a.role_definition_name)) > 0
    ])
    error_message = "Each assignment must include non-empty scope, principal_id, and role_definition_name."
  }
}
