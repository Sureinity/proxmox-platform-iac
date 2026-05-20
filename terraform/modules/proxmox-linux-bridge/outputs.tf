output "id" {
  description = "Unique bridge identifier."
  value       = proxmox_network_linux_bridge.this.id
}

output "name" {
  description = "Linux bridge name."
  value       = proxmox_network_linux_bridge.this.name
}

output "node_name" {
  description = "Node that owns the bridge."
  value       = proxmox_network_linux_bridge.this.node_name
}

output "ports" {
  description = "Ports attached to the bridge."
  value       = proxmox_network_linux_bridge.this.ports
}

output "vlan_aware" {
  description = "Whether the bridge is VLAN-aware."
  value       = proxmox_network_linux_bridge.this.vlan_aware
}
