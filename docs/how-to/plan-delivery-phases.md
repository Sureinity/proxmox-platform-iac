# Plan Delivery Phases

## Goal

Use the roadmap as the working plan for implementation rather than as presentation material.

## How to Use the Phase Plan

1. Start each implementation effort from [implementation phases](../roadmap/implementation-phases.md), not from ad hoc file edits.
2. Read the linked reference and explanation documents for the phase before writing code.
3. Treat each phase exit criterion as the minimum definition of done.
4. Do not skip dependencies. If a phase depends on a missing contract, resolve that first.

## Phase Planning Discipline

For each phase:

- define the intended pull request or work package boundary
- identify which repository areas are allowed to change
- confirm which ADRs the phase depends on
- verify the risks listed in the roadmap still apply
- update the docs if implementation forces a real contract change

## What Not to Do

Do not use the roadmap to justify:

- mixing Terraform, cloud-init, and Ansible responsibilities
- adding extra environments not covered by the architecture
- introducing deferred Version 2 features into Version 1 by convenience
- merging multiple major phases into one large, low-review change

## Practical Sequence

The expected implementation order is:

1. repository foundation and documentation baseline
2. Packer image factory
3. Terraform network layer
4. Terraform image-factory layer integration
5. Terraform workloads layer
6. Ansible baseline configuration
7. CI validation layer
8. inventory and output handoff hardening

If work must be parallelized, keep dependencies intact and preserve the accepted contracts.
