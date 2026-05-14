output "zone_id" {
  description = "Production Proxmox SDN zone ID."
  value       = module.network.zone_id
}

output "vnet_id" {
  description = "Production Proxmox SDN VNet ID."
  value       = module.network.vnet_id
}

output "subnet_cidr" {
  description = "Production SDN subnet CIDR."
  value       = module.network.subnet_cidr
}

output "gateway" {
  description = "Production SDN gateway IP."
  value       = module.network.gateway
}
