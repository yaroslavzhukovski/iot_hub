module "naming" {
  source = "../../modules/naming"

  project                = var.project
  environment            = var.environment
  location               = var.location
  instance               = var.instance
  global_suffix_length   = var.global_suffix_length
  region_short_overrides = var.region_short_overrides
  owner                  = var.owner
  cost_center            = var.cost_center
  data_classification    = var.data_classification
  additional_tags        = var.additional_tags
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = module.naming.names.resource_group
  location = var.location
  tags     = module.naming.tags
}
