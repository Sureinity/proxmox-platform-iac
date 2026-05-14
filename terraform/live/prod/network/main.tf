module "network" {
  source = "../../../modules/proxmox-sdn"

  zone_id            = var.zone_id
  vnet_id            = var.vnet_id
  node_names         = var.node_names
  subnet_cidr        = var.subnet_cidr
  gateway            = var.gateway
  dhcp_start_address = var.dhcp_range.start_address
  dhcp_end_address   = var.dhcp_range.end_address
  enable_snat        = var.enable_snat
}
