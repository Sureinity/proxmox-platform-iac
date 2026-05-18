# ADR 0003: Split Terraform State by Technical Layer

- Status: Accepted
- Date: 2026-05-18

## Context

Networking, template lifecycle, and workload provisioning change at different rates and have different blast radii.

## Decision

Split Terraform state into:

- `network`
- `image-factory`
- `workloads`

## Consequences

- shared-network changes are isolated from routine workload changes
- template lifecycle is independent from workload lifecycle
- future remote backends can apply tighter access control per state boundary
