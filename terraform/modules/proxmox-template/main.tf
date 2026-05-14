resource "proxmox_virtual_environment_vm" "this" {
  name      = var.template_name
  node_name = var.node_name
  vm_id     = var.vm_id

  bios          = var.bios
  template      = true
  started       = false
  scsi_hardware = "virtio-scsi-pci"

  serial_device {}

  vga {
    type = "serial0"
  }

  disk {
    datastore_id = var.vm_datastore_id
    interface    = "scsi0"
    import_from  = var.cloud_image_file_id
    size         = var.disk_size_gb
  }

  memory {
    dedicated = var.memory_mb
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  initialization {
    datastore_id = var.cloud_init_datastore_id

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = var.bootstrap_username
      keys     = var.bootstrap_ssh_public_keys
    }

    dns {
      servers = var.dns_servers
    }

    upgrade = var.cloud_init_upgrade
  }
}
