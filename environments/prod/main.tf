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

module "private_dns" {
  source = "../../modules/private_dns"

  resource_group_name  = module.resource_group.name
  private_dns_zones    = var.private_dns_zones
  vnet_ids             = [module.network.vnet_id]
  registration_enabled = var.registration_enabled
  tags                 = module.naming.tags
}

module "key_vault" {
  source = "../../modules/key_vault"

  key_vault_name             = module.naming.names.key_vault
  location                   = var.location
  resource_group_name        = module.resource_group.name
  tags                       = module.naming.tags
  tenant_id                  = var.tenant_id
  sku_name                   = var.key_vault_sku_name
  soft_delete_retention_days = var.key_vault_soft_delete_retention_days
  purge_protection_enabled   = var.key_vault_purge_protection_enabled

}
