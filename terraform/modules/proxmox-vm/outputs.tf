output "vm_id" {
  description = "Proxmox VM ID."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "Proxmox VM name."
  value       = proxmox_virtual_environment_vm.this.name
}

output "node_name" {
  description = "Proxmox node running the VM."
  value       = proxmox_virtual_environment_vm.this.node_name
}

output "ipv4_address" {
  description = "Configured cloud-init IPv4 address."
  value       = var.ipv4_address
}

output "bootstrap_username" {
  description = "Cloud-init bootstrap username."
  value       = var.bootstrap_username
}
