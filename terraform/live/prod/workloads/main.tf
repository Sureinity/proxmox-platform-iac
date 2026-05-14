module "vm" {
  source = "../../../modules/proxmox-vm"

  for_each = var.vms

  name                      = each.value.name
  node_name                 = coalesce(each.value.node_name, var.default_node_name)
  vm_id                     = each.value.vm_id
  template_vm_id            = var.template_vm_id
  started                   = each.value.started
  on_boot                   = each.value.on_boot
  cpu_cores                 = each.value.cpu_cores
  memory_mb                 = each.value.memory_mb
  bridge                    = coalesce(each.value.bridge, var.default_bridge)
  cloud_init_datastore_id   = var.cloud_init_datastore_id
  ipv4_address              = each.value.ipv4_address
  ipv4_gateway              = try(each.value.ipv4_gateway, null)
  bootstrap_username        = var.bootstrap_username
  bootstrap_ssh_public_keys = var.bootstrap_ssh_public_keys
  dns_servers               = var.dns_servers
}
