# State Boundaries

## Decision

Terraform is split into three technical state boundaries:

- `network`
- `image-factory`
- `workloads`

This split is a project contract. It is not an implementation preference.

## Why the Split Exists

Each boundary has a different lifecycle, review cadence, and blast radius.

| State | Responsibility | Change profile | Blast radius |
| --- | --- | --- | --- |
| `network` | Linux bridge fabric, internal OPNsense firewall VM contract, gateway definitions, and traffic policy contract | Low-frequency, highly reviewed | Platform-wide |
| `image-factory` | Template import and reusable image lifecycle | Periodic rebuilds and patch refreshes | Template consumers |
| `workloads` | Cloned VMs and workload-specific infrastructure | Highest change rate | Individual platform workloads |

Without this split, routine workload changes would carry unnecessary risk to networking and template lifecycles.

## Lifecycle Implications

### `network`

`network` changes should be rare and deliberate. They affect bridge topology, gateway ownership, inter-zone policy, and every consumer of the platform.

### `image-factory`

`image-factory` changes happen when the base image or template standard changes. This layer should be rebuildable without forcing unrelated network edits.

### `workloads`

`workloads` changes are expected to happen most often. This layer is where the Traefik, application, and PostgreSQL VMs are created and updated.

## Dependency Flow

The intended dependency flow is one-way:

1. `network` establishes shared platform connectivity and the internal firewall control-plane contract through OPNsense.
2. `image-factory` establishes the reusable template baseline.
3. `workloads` consumes the network contract and template contract.

The states should not be tightly coupled by hidden assumptions. Shared data passed between them must be explicit and reviewable.

## Blast Radius Control

The split exists to limit impact:

- a workload change must not risk reapplying shared network resources
- a workload change must not redefine bridge attachments, gateway conventions, or firewall policy assumptions
- an image refresh must not risk deleting or renumbering workloads
- a network change must be clearly visible as a cross-platform event

This is also why the repository has only one real environment. There is no synthetic `dev` or `stage` layer to mask production ownership boundaries.

## Future Backend Expectations

Each state is expected to move to a remote backend with:

- independent state storage
- locking
- encryption at rest
- access control scoped to the minimum required operators or automation
- auditable backend access

Backend configuration is intentionally not treated as an inline repository default because backend selection and credentials are organization-specific.

## Implementation Note

The repository already uses the three target root directories under `terraform/live/prod/`. Future implementation work must preserve these boundaries rather than collapsing them back into a single state.

Version 1 network work must not introduce Proxmox SDN as a parallel mechanism. The accepted design is Proxmox Linux bridge fabric at L2 with OPNsense as the L3 and policy control plane.
