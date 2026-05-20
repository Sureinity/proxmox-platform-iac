locals {
  default_ansible_groups = {
    mgmt = "mgmt_nodes"
    edge = "edge_proxies"
    app  = "app_nodes"
    data = "postgresql_nodes"
  }

  default_node_name       = coalesce(var.default_node_name, var.template_contract.template_node_name)
  bootstrap_username      = var.template_contract.bootstrap_username
  template_vm_id          = var.template_contract.template_vm_id
  cloud_init_datastore_id = coalesce(var.cloud_init_datastore_id_override, var.template_contract.cloud_init_storage)

  normalized_vms = {
    for key, vm in var.vms : key => merge(vm, {
      node_name     = coalesce(try(vm.node_name, null), local.default_node_name)
      bridge        = coalesce(try(vm.bridge, null), var.zone_bridges[vm.zone])
      ipv4_gateway  = try(vm.ipv4_gateway, null) != null ? vm.ipv4_gateway : (vm.ipv4_address == "dhcp" ? null : split("/", var.zone_gateways[vm.zone])[0])
      ansible_group = coalesce(try(vm.ansible_group, null), local.default_ansible_groups[vm.zone])
    })
  }
}

module "vm" {
  source = "../../../modules/proxmox-vm"

  for_each = local.normalized_vms

  name                      = each.value.name
  node_name                 = each.value.node_name
  vm_id                     = each.value.vm_id
  template_vm_id            = local.template_vm_id
  started                   = each.value.started
  on_boot                   = each.value.on_boot
  cpu_cores                 = each.value.cpu_cores
  memory_mb                 = each.value.memory_mb
  bridge                    = each.value.bridge
  cloud_init_datastore_id   = local.cloud_init_datastore_id
  ipv4_address              = each.value.ipv4_address
  ipv4_gateway              = each.value.ipv4_gateway
  bootstrap_username        = local.bootstrap_username
  bootstrap_ssh_public_keys = var.bootstrap_ssh_public_keys
  dns_servers               = var.dns_servers
}
