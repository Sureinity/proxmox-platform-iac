# proxmox-template

Reusable module for creating a Proxmox VM template from a downloaded cloud image.

## Purpose

Creates a stopped VM marked as a template, using serial console settings appropriate for Debian cloud images. The module configures SSH public key access only and does not set cloud-init passwords.

## Inputs

- `template_name`
- `node_name`
- `vm_id`
- `cloud_image_file_id`
- `vm_datastore_id`
- `cloud_init_datastore_id`
- `bridge`
- `bootstrap_username`
- `bootstrap_ssh_public_keys`
- Optional sizing, DNS, BIOS, and cloud-init upgrade settings.

## Outputs

- `template_vm_id`
- `template_name`
- `node_name`
- `bootstrap_username`

## Example

```hcl
module "debian_template" {
  source = "../../../modules/proxmox-template"

  template_name             = "tmpl-debian-13"
  node_name                 = "pve01"
  vm_id                     = 100
  cloud_image_file_id       = module.debian_image.file_id
  vm_datastore_id           = "local-lvm"
  cloud_init_datastore_id   = "local-lvm"
  bridge                    = "vmbr0"
  bootstrap_username        = "debian"
  bootstrap_ssh_public_keys = var.bootstrap_ssh_public_keys
}
```
