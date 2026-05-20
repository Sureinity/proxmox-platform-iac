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

## Current State Note

The accepted Version 1 design for this root is the four-zone bridge-and-firewall model above. The current Terraform implementation still reflects SDN-oriented, single-zone assumptions and must be realigned rather than extended as if that older shape were the target.

## Apply Order Dependency

Apply this stack first. The image factory and workload stacks can then reference its bridge conventions, gateway ownership model, and traffic-policy contract.

## Backend Migration

This repository does not hardcode backend credentials. Before team use, add a backend block with credentials supplied outside source control, then run:

```bash
terraform init -migrate-state
```
