resource "azurerm_storage_account" "this" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  is_hns_enabled           = var.enable_hierarchical_namespace

  https_traffic_only_enabled    = true
  min_tls_version               = "TLS1_2"
  public_network_access_enabled = false

  allow_nested_items_to_be_public  = false
  shared_access_key_enabled        = false
  default_to_oauth_authentication  = true
  cross_tenant_replication_enabled = false
  local_user_enabled               = false
  sftp_enabled                     = false

  infrastructure_encryption_enabled = true

  blob_properties {
    versioning_enabled = var.enable_versioning

    delete_retention_policy {
      days = var.retention_days_soft_delete
    }

    container_delete_retention_policy {
      days = var.retention_days_soft_delete
    }
  }

  tags = var.tags
}

resource "azurerm_storage_container" "functions_deploy" {
  name                  = var.functions_deploy_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "digital_twin_data" {
  name                  = var.digital_twin_data_container_name
  storage_account_id    = azurerm_storage_account.this.id
  container_access_type = "private"
}
