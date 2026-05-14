# proxmox-sdn

Reusable module for Proxmox SDN networking.

## Purpose

Creates a simple SDN zone, one VNet, and one subnet with gateway, DHCP range, and optional SNAT. It preserves the original reference intent while making all environment-specific details explicit inputs.

## Inputs

- `zone_id`: SDN zone ID.
- `vnet_id`: VNet ID.
- `node_names`: Proxmox node names where the zone is available.
- `subnet_cidr`: Subnet CIDR.
- `gateway`: Gateway IP address.
- `dhcp_start_address`: DHCP start address.
- `dhcp_end_address`: DHCP end address.
- `enable_snat`: Enables subnet SNAT.
- `ipam`, `dhcp`, `mtu`: Proxmox SDN settings.

## Outputs

- `zone_id`
- `vnet_id`
- `subnet_cidr`
- `gateway`

## Example

```hcl
module "platform_network" {
  source = "../../../modules/proxmox-sdn"

  zone_id     = "net1"
  vnet_id     = "vnet1"
  node_names  = ["pve"]
  subnet_cidr = "10.0.50.0/24"
  gateway     = "10.0.50.1"

  dhcp_start_address = "10.0.50.100"
  dhcp_end_address   = "10.0.50.150"
}
```
