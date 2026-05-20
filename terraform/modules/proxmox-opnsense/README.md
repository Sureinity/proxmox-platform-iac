# proxmox-opnsense

Reusable module for the internal OPNsense firewall appliance lifecycle.

## Purpose

Clones an approved OPNsense template and attaches the required network interfaces for the upstream, management, DMZ, application, and data zones.

## Inputs

- `name`
- `node_name`
- `vm_id`
- `template_vm_id`
- `network_interfaces`
- Optional CPU, memory, boot, and description settings

## Outputs

- `vm_id`
- `name`
- `node_name`
- `network_interfaces`

## Example

```hcl
module "opnsense" {
  source = "../../../modules/proxmox-opnsense"

  name           = "prod-opnsense-01"
  node_name      = "pve01"
  vm_id          = 150
  template_vm_id = 9000

  network_interfaces = [
    { role = "upstream", bridge = "vmbr0" },
    { role = "mgmt", bridge = "vmbr10" },
    { role = "edge", bridge = "vmbr20" },
    { role = "app", bridge = "vmbr30" },
    { role = "data", bridge = "vmbr40" },
  ]
}
```
