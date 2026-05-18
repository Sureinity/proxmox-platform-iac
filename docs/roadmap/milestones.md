# Milestones

## M1: Repository Foundation

Outcome:
Diataxis documentation, ADR baseline, repository contracts, and a roadmap that defines the implementation order.

## M2: Packer Image Factory

Outcome:
An immutable image pipeline exists and produces the approved base artifact for Proxmox template creation.

## M3: Network Layer

Outcome:
The `network` state implements the four-zone segmentation model and shared connectivity contract.

## M4: Image-Factory Integration

Outcome:
Terraform can import the approved image artifact into Proxmox and create a reusable template.

## M5: Workload Provisioning

Outcome:
Terraform provisions the Traefik, application, and PostgreSQL VMs and publishes the inventory handoff contract.

## M6: Ansible Baseline

Outcome:
Ansible configures the guest baseline and begins the service configuration path without crossing into infrastructure ownership.

## M7: Validation CI

Outcome:
Pull requests receive validation-only checks for Terraform, Ansible, and static configuration security.

## M8: Inventory Handoff Hardening

Outcome:
Terraform outputs and Ansible inventory generation are consistent, documented, and suitable for repeatable operator use.
