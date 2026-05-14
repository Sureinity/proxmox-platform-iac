module "network" {
  source = "../../../modules/proxmox-sdn"

  zone_id     = var.zone_id
  vnet_id     = var.vnet_id
  node_names  = var.node_names
  subnet_cidr = var.subnet_cidr
  gateway     = var.gateway
  dhcp_range  = var.dhcp_range
  enable_snat = var.enable_snat
}
