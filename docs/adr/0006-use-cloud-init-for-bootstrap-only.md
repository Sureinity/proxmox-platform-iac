# ADR 0006: Use Cloud-Init for Bootstrap Only

- Status: Accepted
- Date: 2026-05-18

## Context

Cloud-init is required for first-boot provisioning, but it can easily become a second configuration-management layer if left unconstrained.

## Decision

Limit cloud-init to:

- hostname
- SSH user
- SSH keys
- network

## Consequences

- packages, users beyond bootstrap, and service configuration stay out of cloud-init
- Terraform passes only bootstrap data into guest initialization
- long-lived host configuration belongs in Ansible
