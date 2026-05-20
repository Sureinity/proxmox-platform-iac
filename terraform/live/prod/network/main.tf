locals {
  required_bridge_roles = ["upstream", "mgmt", "edge", "app", "data"]

  bridge_fabric = {
    for role, bridge in var.bridge_fabric : role => merge(
      {
        autostart  = true
        comment    = null
        mtu        = 1500
        ports      = []
        vlan_aware = false
        vids       = null
      },
      bridge
    )
  }

  opnsense_network_interfaces = [
    {
      role   = "upstream"
      bridge = local.bridge_fabric["upstream"].name
      model  = "virtio"
    },
    {
      role   = "mgmt"
      bridge = local.bridge_fabric["mgmt"].name
      model  = "virtio"
    },
    {
      role   = "edge"
      bridge = local.bridge_fabric["edge"].name
      model  = "virtio"
    },
    {
      role   = "app"
      bridge = local.bridge_fabric["app"].name
      model  = "virtio"
    },
    {
      role   = "data"
      bridge = local.bridge_fabric["data"].name
      model  = "virtio"
    },
  ]

  traffic_policy_contract = {
    default_action = "deny"
    allowed_flows = [
      {
        source      = "upstream"
        destination = "edge"
        services    = ["80/tcp", "443/tcp"]
        purpose     = "Published ingress through Traefik."
      },
      {
        source      = "mgmt"
        destination = "all"
        services    = ["ssh", "admin", "monitoring"]
        purpose     = "Required administrative access only."
      },
      {
        source      = "edge"
        destination = "app"
        services    = ["reverse-proxy-upstream"]
        purpose     = "Reverse proxy to application traffic only."
      },
      {
        source      = "app"
        destination = "data"
        services    = ["5432/tcp"]
        purpose     = "Application-to-PostgreSQL traffic only."
      },
    ]
  }
}

module "bridge" {
  for_each = local.bridge_fabric

  source = "../../../modules/proxmox-linux-bridge"

  node_name  = var.node_name
  name       = each.value.name
  comment    = each.value.comment
  autostart  = each.value.autostart
  mtu        = each.value.mtu
  ports      = each.value.ports
  vlan_aware = each.value.vlan_aware
  vids       = each.value.vids
}

module "opnsense" {
  source = "../../../modules/proxmox-opnsense"

  name               = var.opnsense_name
  node_name          = var.node_name
  vm_id              = var.opnsense_vm_id
  template_vm_id     = var.opnsense_template_vm_id
  cpu_cores          = var.opnsense_cpu_cores
  memory_mb          = var.opnsense_memory_mb
  started            = var.opnsense_started
  on_boot            = var.opnsense_on_boot
  description        = "Internal OPNsense control plane for the Version 1 platform."
  network_interfaces = local.opnsense_network_interfaces
}
