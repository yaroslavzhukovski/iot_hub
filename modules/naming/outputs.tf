output "base_name" {
  description = "Canonical base name composed from project, environment, region short code, and instance."
  value       = local.base_name
}

output "region_short" {
  description = "Short code for the selected Azure region."
  value       = local.region_short
}

output "tags" {
  description = "Merged standard and additional tags."
  value       = local.tags
}

output "names" {
  description = "Map of standardized resource names for core platform resources."
  value       = local.names
}
