output "vm_id" {
  description = "Firewall VM ID."
  value       = proxmox_virtual_environment_vm.this.vm_id
}

output "name" {
  description = "Firewall VM name."
  value       = proxmox_virtual_environment_vm.this.name
}

output "node_name" {
  description = "Node where the firewall VM runs."
  value       = proxmox_virtual_environment_vm.this.node_name
}

output "network_interfaces" {
  description = "Firewall network interface role-to-bridge mapping."
  value = {
    for iface in var.network_interfaces : iface.role => {
      bridge = iface.bridge
      model  = iface.model
    }
  }
}
