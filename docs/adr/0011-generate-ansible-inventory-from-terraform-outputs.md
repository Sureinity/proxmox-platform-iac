# ADR 0011: Generate Ansible Inventory from Terraform Outputs

- Status: Accepted
- Date: 2026-05-18

## Context

The platform needs a stable handoff from Terraform workload provisioning to Ansible guest configuration.

## Decision

Version 1 inventory is generated from a Terraform output contract named `ansible_inventory`.

## Consequences

- the `workloads` state must expose a consumer-oriented inventory output
- manual host-by-host inventory editing should be minimized
- dynamic inventory is not required in Version 1
