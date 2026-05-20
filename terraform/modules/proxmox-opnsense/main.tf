resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name
  vm_id     = var.vm_id
  started   = var.started
  on_boot   = var.on_boot

  description     = var.description
  stop_on_destroy = true

  clone {
    vm_id = var.template_vm_id
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
  }

  dynamic "network_device" {
    for_each = var.network_interfaces

    content {
      bridge = network_device.value.bridge
      model  = network_device.value.model
    }
  }
}
