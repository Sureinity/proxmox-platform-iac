output "bridges" {
  description = "Bridge fabric keyed by logical role."
  value = {
    for role, bridge in module.bridge : role => {
      id         = bridge.id
      name       = bridge.name
      node_name  = bridge.node_name
      ports      = bridge.ports
      vlan_aware = bridge.vlan_aware
    }
  }
}

output "zone_bridges" {
  description = "Zone-to-bridge mapping for downstream consumers."
  value = {
    mgmt = module.bridge["mgmt"].name
    edge = module.bridge["edge"].name
    app  = module.bridge["app"].name
    data = module.bridge["data"].name
  }
}

output "zone_gateways" {
  description = "Gateway CIDR addresses owned by OPNsense for each zone."
  value       = var.zone_gateways
}

output "opnsense_vm" {
  description = "Internal OPNsense firewall VM contract."
  value = {
    name               = module.opnsense.name
    vm_id              = module.opnsense.vm_id
    node_name          = module.opnsense.node_name
    network_interfaces = module.opnsense.network_interfaces
    dhcp_zones         = sort(tolist(var.opnsense_dhcp_zones))
    nat_enabled        = var.opnsense_nat_enabled
  }
}

output "traffic_policy_contract" {
  description = "Version 1 traffic policy contract enforced by the internal firewall control plane."
  value       = local.traffic_policy_contract
}
