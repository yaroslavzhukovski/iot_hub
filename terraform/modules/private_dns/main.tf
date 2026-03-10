resource "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones
  name     = each.value.name

  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, each.value.tags)
}

locals {
  zone_vnet_links = {
    for pair in setproduct(keys(var.private_dns_zones), keys(var.vnet_ids)) :
    "${pair[0]}|${pair[1]}" => {
      zone_key = pair[0]
      vnet_key = pair[1]
      vnet_id  = var.vnet_ids[pair[1]]
    }
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.zone_vnet_links

  name                  = "lnk-${each.value.zone_key}-${each.value.vnet_key}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.zone_key].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = var.registration_enabled
  tags                  = var.tags
}
