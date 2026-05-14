output "template_vm_id" {
  description = "Proxmox VM ID of the created template."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "template_name" {
  description = "Name of the created template."
  value       = proxmox_virtual_environment_vm.this.name
}

output "node_name" {
  description = "Node where the template was created."
  value       = proxmox_virtual_environment_vm.this.node_name
}

output "bootstrap_username" {
  description = "Cloud-init bootstrap username baked into the template."
  value       = var.bootstrap_username
}
