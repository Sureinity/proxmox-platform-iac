# proxmox-linux-bridge

Reusable module for Proxmox Linux bridge management.

## Purpose

Creates a Linux bridge on a Proxmox node as part of the Version 1 L2 transport fabric.

## Inputs

- `node_name`
- `name`
- Optional bridge addressing, ports, comment, MTU, and VLAN-awareness settings

## Outputs

- `id`
- `name`
- `node_name`
- `ports`
- `vlan_aware`

## Example

```hcl
module "mgmt_bridge" {
  source = "../../../modules/proxmox-linux-bridge"

  node_name = "pve01"
  name      = "vmbr10"
  comment   = "Management bridge"
}
```
