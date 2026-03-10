locals {
  default_region_short = {
    swedencentral = "swec"
    swedensouth   = "swes"
    westeurope    = "weu"
    northeurope   = "neu"
    norwayeast    = "noe"
    norwaywest    = "now"
    eastus        = "eus"
    eastus2       = "eus2"
    westus2       = "wus2"
    westus3       = "wus3"
    centralus     = "cus"
    southcentralus = "scus"
    uksouth       = "uks"
    ukwest        = "ukw"
  }

  location_normalized = replace(lower(trimspace(var.location)), "/[^0-9a-z]/", "")
  project_normalized  = trim(replace(lower(var.project), "/[^0-9a-z]/", "-"), "-")
  env_normalized      = trim(replace(lower(var.environment), "/[^0-9a-z]/", "-"), "-")
  instance_normalized = trim(replace(lower(var.instance), "/[^0-9a-z]/", ""), "")

  region_short_map = merge(local.default_region_short, {
    for k, v in var.region_short_overrides : lower(trimspace(k)) => lower(trimspace(v))
  })

  region_short = lookup(
    local.region_short_map,
    local.location_normalized,
    substr(local.location_normalized, 0, 4)
  )

  base_name = join(var.name_separator, compact([
    local.project_normalized,
    local.env_normalized,
    local.region_short,
    local.instance_normalized
  ]))

  global_suffix = var.global_suffix_length > 0 ? substr(
    md5(join("|", [
      local.project_normalized,
      local.env_normalized,
      local.location_normalized,
      local.instance_normalized
    ])),
    0,
    var.global_suffix_length
  ) : ""

  names = {
    resource_group = "rg-${local.base_name}"
    vnet           = "vnet-${local.base_name}"
    snet_function  = "snet-func-${local.base_name}"
    snet_pe        = "snet-pe-${local.base_name}"
    key_vault      = substr(join("-", compact(["kv-${local.base_name}", local.global_suffix])), 0, 24)
    function_app   = join("-", compact(["func-${local.base_name}", local.global_suffix]))
    iot_hub        = join("-", compact(["iothub-${local.base_name}", local.global_suffix]))
    digital_twins  = "adt-${local.base_name}"
    app_insights   = "appi-${local.base_name}"
    log_analytics  = "law-${local.base_name}"

    # Storage accounts must be 3-24 chars, lowercase letters and numbers only.
    storage_account = substr(
      replace(
        "st${local.project_normalized}${local.env_normalized}${local.region_short}${local.instance_normalized}${local.global_suffix}",
        "/[^0-9a-z]/",
        ""
      ),
      0,
      24
    )
  }

  standard_tags = {
    Environment        = local.env_normalized
    Project            = local.project_normalized
    Region             = local.location_normalized
    RegionShort        = local.region_short
    Owner              = lower(trimspace(var.owner))
    ManagedBy          = "terraform"
    DataClassification = lower(trimspace(var.data_classification))
  }

  optional_tags = {
    CostCenter = trimspace(var.cost_center)
  }

  tags = merge(
    local.standard_tags,
    { for k, v in local.optional_tags : k => v if length(v) > 0 },
    var.additional_tags
  )
}
