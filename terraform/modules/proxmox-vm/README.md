# proxmox-vm

Reusable module for creating a cloned Proxmox VM with cloud-init.

## Purpose

Clones a VM from an existing template and configures CPU, memory, network, cloud-init IP settings, DNS, and SSH key-based bootstrap access.

## Inputs

- `name`
- `node_name`
- `vm_id`
- `template_vm_id`
- `bridge`
- `cloud_init_datastore_id`
- `ipv4_address`
- `ipv4_gateway`
- `bootstrap_username`
- `bootstrap_ssh_public_keys`
- Optional CPU, memory, boot, started, and DNS settings.

## Outputs

- `vm_id`
- `name`
- `node_name`
- `ipv4_address`
- `bootstrap_username`

## Example

```hcl
module "vm" {
  source = "../../../modules/proxmox-vm"

  name                     = "app-01"
  node_name                = "pve01"
  vm_id                    = 110
  template_vm_id           = 100
  bridge                   = "vnet1"
  cloud_init_datastore_id  = "local-lvm"
  ipv4_address             = "10.0.50.110/24"
  ipv4_gateway             = "10.0.50.1"
  bootstrap_username       = "debian"
  bootstrap_ssh_public_keys = var.bootstrap_ssh_public_keys
}
```
