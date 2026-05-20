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

## Outputs

- `vms`
- `ansible_inventory`

The `ansible_inventory` output is the accepted Version 1 contract for generating `ansible/inventories/prod/hosts.yml`.

## Current State Note

The current Terraform implementation still assumes a single default bridge and still exposes `ansible_inventory_hosts` as a compatibility output. Both are implementation drift from the accepted multi-zone bridge-and-firewall contract and should be removed during the workload and handoff hardening phases.

## Apply Order Dependency

Apply after:

1. `terraform/live/prod/network`
2. `terraform/live/prod/image-factory`

## Backend Migration

Configure a remote backend outside source control before team use, then run:

```bash
terraform init -migrate-state
```
