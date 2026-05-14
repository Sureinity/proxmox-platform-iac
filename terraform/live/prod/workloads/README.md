# Production Workloads Stack

## Owns

This root module owns cloned production VMs only.

It configures Proxmox VM lifecycle settings and cloud-init bootstrap access for Ansible handoff.

## Must Not Own

This stack must not own SDN primitives, cloud image downloads, VM templates, guest package configuration, application deployment, or Ansible execution.

## Required Variables

- `proxmox_endpoint`
- `proxmox_api_token`
- `template_vm_id`
- `default_node_name`
- `default_bridge`
- `cloud_init_datastore_id`
- `bootstrap_username`
- `bootstrap_ssh_public_keys`
- `vms`

## Outputs

- `vms`
- `ansible_inventory_hosts`

The `ansible_inventory_hosts` output is the source for generating `ansible/inventories/prod/hosts.yml`.

## Apply Order Dependency

Apply after:

1. `terraform/live/prod/network`
2. `terraform/live/prod/image-factory`

## Backend Migration

Configure a remote backend outside source control before team use, then run:

```bash
terraform init -migrate-state
```
