# Production Network Stack

## Owns

This root module owns the production Linux bridge fabric and internal firewall contract for the platform:

- `vmbr0` upstream transit or WAN connectivity
- `vmbr10` for `mgmt`
- `vmbr20` for `edge`
- `vmbr30` for `app`
- `vmbr40` for `data`
- the internal OPNsense firewall VM role and interface placement contract
- zone gateway definitions and the intended traffic-policy contract
- optional DHCP or NAT behavior only where explicitly needed through OPNsense

## Must Not Own

This stack must not create cloud images, VM templates, cloned workload VMs, or guest OS configuration.

## Required Variables

- `proxmox_endpoint`
- `proxmox_api_token`
- `node_name`
- `bridge_fabric`
- `opnsense_vm_id`
- `opnsense_template_vm_id`

Optional variables cover:

- fixed `zone_gateways`
- OPNsense CPU and memory sizing
- explicit DHCP zone ownership
- explicit NAT requirement

## Outputs

- `bridges`
- `zone_bridges`
- `zone_gateways`
- `opnsense_vm`
- `traffic_policy_contract`

## Apply Order Dependency

Apply this stack first. The image factory and workload stacks can then reference its bridge conventions, gateway ownership model, and traffic-policy contract.

## Backend Migration

This repository does not hardcode backend credentials. Before team use, add a backend block with credentials supplied outside source control, then run:

```bash
terraform init -migrate-state
```
