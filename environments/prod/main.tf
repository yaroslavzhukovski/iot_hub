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

module "network" {
  source = "../../modules/network"

  vnet_name                   = module.naming.names.vnet
  location                    = var.location
  parent_id                   = module.resource_group.id
  address_space               = var.network_address_space
  subnets                     = var.subnets
  flow_timeout_in_minutes     = var.flow_timeout_in_minutes
  enable_vnet_encryption      = var.enable_vnet_encryption
  vnet_encryption_enforcement = var.vnet_encryption_enforcement
  enable_telemetry            = var.enable_network_telemetry
  tags                        = module.naming.tags
}
