output "zone_id" {
  description = "Created Proxmox SDN zone identifier."
  value       = proxmox_sdn_zone_simple.this.id
}

output "vnet_id" {
  description = "Created Proxmox SDN VNet identifier."
  value       = proxmox_sdn_vnet.this.id
}

output "subnet_cidr" {
  description = "Configured SDN subnet CIDR."
  value       = proxmox_sdn_subnet.this.cidr
}

output "gateway" {
  description = "Configured SDN subnet gateway."
  value       = proxmox_sdn_subnet.this.gateway
}
