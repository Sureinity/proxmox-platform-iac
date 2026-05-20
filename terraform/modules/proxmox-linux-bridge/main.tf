resource "proxmox_network_linux_bridge" "this" {
  node_name = var.node_name
  name      = var.name

  address    = var.address
  address6   = var.address6
  autostart  = var.autostart
  comment    = var.comment
  gateway    = var.gateway
  gateway6   = var.gateway6
  mtu        = var.mtu
  ports      = var.ports
  vlan_aware = var.vlan_aware
  vids       = var.vids
}
