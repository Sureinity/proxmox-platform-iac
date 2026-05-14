# Production Image Factory Stack

## Owns

This root module owns production image-factory resources:

- Debian cloud image download
- Debian VM template creation
- Cloud-init bootstrap user and SSH public keys for template-based provisioning

## Must Not Own

This stack must not own SDN resources, cloned workload VMs, post-boot OS configuration, application services, or Ansible execution.

## Required Variables

- `proxmox_endpoint`
- `proxmox_api_token`
- `node_name`
- `image_datastore_id`
- `vm_datastore_id`
- `cloud_init_datastore_id`
- `image_url`
- `template_name`
- `template_vm_id`
- `template_bridge`
- `bootstrap_username`
- `bootstrap_ssh_public_keys`

## Outputs

- `image_file_id`
- `template_vm_id`
- `template_name`
- `template_node_name`
- `bootstrap_username`

## Apply Order Dependency

Apply after `terraform/live/prod/network` when templates should attach to a production VNet. Apply before `terraform/live/prod/workloads`.

## Backend Migration

Configure a remote backend outside source control before team use, then run:

```bash
terraform init -migrate-state
```
