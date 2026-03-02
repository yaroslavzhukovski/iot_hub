resource "azurerm_private_dns_zone" "this" {
  for_each = var.private_dns_zones
  name     = each.value.name

  resource_group_name = var.resource_group_name
  tags                = merge(var.tags, each.value.tags)
}

locals {
  zone_vnet_links = {
    for pair in setproduct(keys(var.private_dns_zones), tolist(var.vnet_ids)) :
    "${pair[0]}|${pair[1]}" => {
      zone_key = pair[0]
      vnet_id  = pair[1]
    }
  }
}
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = local.zone_vnet_links

  name                  = "lnk-${each.value.zone_key}-${substr(md5(each.value.vnet_id), 0, 6)}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.zone_key].name
  virtual_network_id    = each.value.vnet_id
  registration_enabled  = var.registration_enabled
  tags                  = var.tags
}
