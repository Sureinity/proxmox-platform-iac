resource "proxmox_download_file" "this" {
  content_type = "import"
  datastore_id = var.datastore_id
  node_name    = var.node_name
  url          = var.image_url
}
