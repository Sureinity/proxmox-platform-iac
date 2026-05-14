module "debian_image" {
  source = "../../../modules/proxmox-cloud-image"

  node_name    = var.node_name
  datastore_id = var.image_datastore_id
  image_url    = var.image_url
}

module "debian_template" {
  source = "../../../modules/proxmox-template"

  template_name             = var.template_name
  node_name                 = var.node_name
  vm_id                     = var.template_vm_id
  cloud_image_file_id       = module.debian_image.file_id
  vm_datastore_id           = var.vm_datastore_id
  cloud_init_datastore_id   = var.cloud_init_datastore_id
  disk_size_gb              = var.template_disk_size_gb
  memory_mb                 = var.template_memory_mb
  bridge                    = var.template_bridge
  bootstrap_username        = var.bootstrap_username
  bootstrap_ssh_public_keys = var.bootstrap_ssh_public_keys
  dns_servers               = var.dns_servers
}
