# proxmox-cloud-image

Reusable module for downloading cloud images into Proxmox storage.

## Purpose

Downloads an HTTPS cloud image URL to a Proxmox datastore as importable image content.

## Inputs

- `node_name`: Proxmox node that downloads the image.
- `datastore_id`: Datastore that stores the imported image.
- `image_url`: HTTPS image URL ending in `qcow2`, `img`, or `raw`.

## Outputs

- `file_id`: Proxmox file ID used by template creation.
- `node_name`
- `datastore_id`

## Example

```hcl
module "debian_image" {
  source = "../../../modules/proxmox-cloud-image"

  node_name    = "pve01"
  datastore_id = "local"
  image_url    = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}
```
