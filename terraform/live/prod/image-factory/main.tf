locals {
  manifest = try(jsondecode(file(var.packer_manifest_path)), null)

  manifest_builds = local.manifest != null ? try(local.manifest.builds, []) : []
  latest_build    = length(local.manifest_builds) > 0 ? local.manifest_builds[length(local.manifest_builds) - 1] : null

  manifest_custom_data = merge(
    local.manifest != null ? try(local.manifest.custom_data, {}) : {},
    local.latest_build != null ? try(local.latest_build.custom_data, {}) : {}
  )

  template_contract = {
    manifest_loaded      = local.manifest != null
    manifest_build_name  = try(local.latest_build.name, null)
    build_id             = try(local.manifest_custom_data.build_id, null)
    debian_major_version = try(local.manifest_custom_data.debian_major_version, null)
    template_profile     = try(local.manifest_custom_data.template_profile, null)
    template_name        = try(local.manifest_custom_data.template_name, null)
    template_node_name   = try(local.manifest_custom_data.template_node_name, null)
    template_vm_id       = try(tonumber(local.latest_build.artifact_id), null)
    bootstrap_username   = try(local.manifest_custom_data.bootstrap_username, null)
    bootstrap_bridge     = try(local.manifest_custom_data.bootstrap_bridge, null)
    cloud_init_storage   = try(local.manifest_custom_data.cloud_init_pool, null)
    source_template_name = try(local.manifest_custom_data.source_template_name, null)
    packer_manifest_path = var.packer_manifest_path
  }
}
