resource "proxmox_sdn_zone_simple" "this" {
  id    = var.zone_id
  nodes = var.node_names
  ipam  = var.ipam
  mtu   = var.mtu
  dhcp  = var.dhcp
}

resource "proxmox_sdn_vnet" "this" {
  id   = var.vnet_id
  zone = proxmox_sdn_zone_simple.this.id
}

resource "proxmox_sdn_subnet" "this" {
  cidr    = var.subnet_cidr
  vnet    = proxmox_sdn_vnet.this.id
  gateway = var.gateway
  snat    = var.enable_snat

  dhcp_range = var.dhcp_range
}
