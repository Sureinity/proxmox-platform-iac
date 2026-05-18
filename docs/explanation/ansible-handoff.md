# Ansible Handoff

## Purpose

The handoff between Terraform, cloud-init, and Ansible is a hard boundary in this repository. It prevents guest configuration from leaking into infrastructure code and keeps provisioning behavior auditable.

## Ownership Contract

| Concern | Owner | Notes |
| --- | --- | --- |
| Proxmox SDN, VM lifecycle, template selection | Terraform | Infrastructure lifecycle only |
| Hostname, SSH user, SSH keys, first-boot network | Cloud-init | Bootstrap only |
| Packages, users, SSH hardening, runtime, service configuration, monitoring | Ansible | Ongoing guest configuration |

## What Terraform Owns

Terraform owns:

- network connectivity contracts
- VM creation and destruction
- VM placement and identity metadata
- cloud-init input values
- the inventory handoff output consumed by Ansible

Terraform must not:

- install packages on guests
- apply SSH hardening
- configure Docker or other runtimes
- run service configuration
- call Ansible through provisioners

## What Cloud-init Owns

Cloud-init owns only:

- hostname
- SSH bootstrap user
- SSH public keys
- first-boot network configuration

Cloud-init must remain small and deterministic. If a change belongs to long-lived host configuration, it belongs in Ansible instead.

## What Ansible Owns

Ansible owns:

- baseline OS packages
- long-lived automation users
- SSH daemon hardening
- Docker or container runtime setup
- workload service configuration
- monitoring agent or hook configuration when introduced

Ansible begins after Terraform has created reachable hosts and cloud-init has made the bootstrap identity usable.

## Inventory Contract

Version 1 expects the `workloads` state to publish a stable Terraform output named `ansible_inventory`.

That output is the contract between infrastructure provisioning and guest configuration. The exact helper command that renders the output into `ansible/inventories/prod/hosts.yml` may be added later, but the data contract itself is part of the architecture now.

## Failure Boundary

If guest configuration fails:

- Terraform state should still describe the infrastructure accurately
- the failure should be visible in Ansible output
- recovery should happen through Ansible reruns or targeted host remediation

This separation is intentional. It preserves clear operational ownership and avoids hiding configuration drift inside infrastructure apply workflows.
