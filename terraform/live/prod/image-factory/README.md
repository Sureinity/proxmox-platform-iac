# Production Image Factory Stack

## Owns

This root module owns the Terraform-side image-factory integration boundary for production:

- approved template metadata needed by downstream Terraform
- non-secret template identity values passed to `workloads`
- the clean lifecycle boundary between image construction and workload cloning

## Must Not Own

This stack must not own Linux bridge fabric, the internal firewall VM, cloned workload VMs, post-boot OS configuration, application services, or Ansible execution.

It also must not become the primary image builder. Packer owns image and template construction in Version 1.

## Current State Note

The current Terraform implementation in this root still performs cloud image download and template creation. That is transition-state drift from the accepted architecture and should be refactored toward Packer-produced template consumption rather than expanded further.

## Apply Order Dependency

Apply after the Packer image build has produced an approved template artifact. Apply after `terraform/live/prod/network` when template attachment depends on platform networking. Apply before `terraform/live/prod/workloads`.

## Backend Migration

Configure a remote backend outside source control before team use, then run:

```bash
terraform init -migrate-state
```
