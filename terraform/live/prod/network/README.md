# Production Network Stack

## Owns

This root module owns the production Proxmox SDN stack:

- Simple SDN zone
- VNet
- Subnet
- Gateway
- DHCP range
- SNAT setting

## Must Not Own

This stack must not create cloud images, VM templates, cloned VMs, or guest OS configuration.

## Required Variables

Set values with a local `terraform.tfvars` file copied from `terraform.tfvars.example`, environment variables, or a secret manager. Do not commit real `.tfvars`.

- `proxmox_endpoint`
- `proxmox_api_token`
- `zone_id`
- `vnet_id`
- `node_names`
- `subnet_cidr`
- `gateway`
- `dhcp_range`

## Outputs

- `zone_id`
- `vnet_id`
- `subnet_cidr`
- `gateway`

## Apply Order Dependency

Apply this stack first. The image factory and workload stacks can then reference its VNet and subnet values.

## Backend Migration

This repository does not hardcode backend credentials. Before team use, add a backend block with credentials supplied outside source control, then run:

```bash
terraform init -migrate-state
```
