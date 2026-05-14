output "file_id" {
  description = "Proxmox file identifier for the downloaded cloud image."
  value       = proxmox_download_file.this.id
}

output "node_name" {
  description = "Node where the image was downloaded."
  value       = var.node_name
}

output "datastore_id" {
  description = "Datastore where the image was downloaded."
  value       = var.datastore_id
}
