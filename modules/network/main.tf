module "vnet" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  name          = var.vnet_name
  location      = var.location
  parent_id     = var.parent_id
  address_space = var.address_space
  tags          = var.tags

  # Avoid forcing public DNS resolvers; rely on Azure-provided DNS to work well with Private DNS zones.
  # (No dns_servers block)

  enable_vm_protection    = false
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  encryption = var.enable_vnet_encryption ? {
    enabled     = true
    enforcement = var.vnet_encryption_enforcement
  } : {
    enabled     = false
    enforcement = "AllowUnencrypted"
  }

  subnets = var.subnets

  enable_telemetry = var.enable_telemetry
}
