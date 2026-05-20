# Production Workloads Stack

## Owns

This root module owns cloned production VMs only.

Version 1 workload scope is:

- admin or jump VM in the `mgmt` zone
- Traefik reverse proxy VM in the `edge` zone
- application VM in the `app` zone
- PostgreSQL VM in the `data` zone

It configures Proxmox VM lifecycle settings and cloud-init bootstrap access for Ansible handoff.

## Must Not Own

This stack must not own Linux bridge fabric, the internal firewall VM, firewall policy, cloud image downloads, VM templates, guest package configuration, application deployment, or Ansible execution.

## Required Variables

- `proxmox_endpoint`
- `proxmox_api_token`
- `template_contract`
- `zone_bridges`
- `zone_gateways`
- `bootstrap_ssh_public_keys`
- `vms`

Optional variables cover:

- default node override
- cloud-init datastore override
- DNS servers

## Outputs

- `vms`
- `ansible_inventory`

The `ansible_inventory` output is the accepted Version 1 contract for generating `ansible/inventories/prod/hosts.yml`.

## Current State Note

The current Terraform implementation now derives bridge and gateway placement from the zone contract. The remaining compatibility output is `ansible_inventory_hosts`, which should be retired during the handoff hardening phase.

## Apply Order Dependency

Apply after:

1. `terraform/live/prod/network`
2. `terraform/live/prod/image-factory`

## Backend Migration

Configure a remote backend outside source control before team use, then run:

```bash
terraform init -migrate-state
```
