# Production Image Factory Stack

## Owns

This root module owns the Terraform-side image-factory integration boundary for production:

- generated Packer manifest consumption
- approved template metadata needed by downstream Terraform
- non-secret template identity values passed to `workloads`
- the clean lifecycle boundary between image construction and workload cloning

## Must Not Own

This stack must not own Linux bridge fabric, the internal firewall VM, cloned workload VMs, post-boot OS configuration, application services, or Ansible execution.

It also must not become the primary image builder. Packer owns image and template construction in Version 1.

## Required Variables

- `packer_manifest_path`

The default example path points at the generated Phase 2 Packer manifest. The manifest file itself is not committed and must exist locally before plans or applies can surface real template values.

## Outputs

- `template_contract`
- `template_vm_id`
- `template_name`
- `template_node_name`
- `bootstrap_username`

## Apply Order Dependency

Apply after the Packer image build has produced an approved template artifact. Apply after `terraform/live/prod/network` when template attachment depends on platform networking. Apply before `terraform/live/prod/workloads`.

## Backend Migration

Configure a remote backend outside source control before team use, then run:

```bash
terraform init -migrate-state
```
