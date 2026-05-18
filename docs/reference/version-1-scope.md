# Version 1 Scope

## Included in Version 1

Version 1 includes the core platform contracts and first delivery surface:

- secure multi-tier application platform pattern
- four-zone network model: `mgmt`, `edge`, `app`, `data`
- `terraform/live/prod/` as the only real environment
- Terraform state split into `network`, `image-factory`, and `workloads`
- capability-based Terraform module strategy
- Packer image factory as the selected image strategy
- cloud-init for hostname, SSH user, SSH keys, and network only
- Ansible for guest OS and service configuration
- three workload VMs: Traefik proxy, application, and PostgreSQL
- reverse proxy ingress only
- environment-variable secret injection with committed `.tfvars.example`
- Terraform `ansible_inventory` output as the Version 1 inventory contract
- validation-only GitHub Actions

## Explicitly Deferred from Version 1

The following items are intentionally deferred:

- WAF controls
- SOPS-managed encrypted secret files
- dynamic Ansible inventory
- monitoring VM as a separate workload

## What Deferred Means

Deferred does not mean rejected. It means:

- the capability is not required to complete Version 1
- implementation work should not quietly depend on it
- documentation must not describe it as already present

## Version 1 Delivery Standard

Version 1 is complete when the repository can support:

- documented architecture and implementation sequencing
- repeatable image, network, workload, and guest-configuration layers
- a clear Terraform-to-Ansible handoff
- CI validation that does not require live infrastructure changes

Version 1 is not required to solve every future platform concern. It is required to establish the correct platform contracts and a defensible first delivery baseline.
