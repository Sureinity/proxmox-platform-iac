output "image_file_id" {
  description = "Proxmox file ID for the downloaded Debian cloud image."
  value       = module.debian_image.file_id
}

output "template_vm_id" {
  description = "Proxmox VM ID for the Debian template."
  value       = module.debian_template.template_vm_id
}

output "template_name" {
  description = "Debian template name."
  value       = module.debian_template.template_name
}

output "template_node_name" {
  description = "Node where the Debian template exists."
  value       = module.debian_template.node_name
}

output "bootstrap_username" {
  description = "Cloud-init bootstrap username for downstream workload and Ansible handoff."
  value       = module.debian_template.bootstrap_username
}
