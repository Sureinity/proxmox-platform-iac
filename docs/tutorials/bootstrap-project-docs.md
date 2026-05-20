# Bootstrap the Project Documentation

## Purpose

This tutorial orients a new engineer to the repository architecture and implementation sequence. It is not a deployment runbook.

By the end of this tutorial, you should understand:

- what the platform is trying to deliver
- how responsibilities are split across tools
- which documents define hard project contracts
- how the planned delivery phases build on each other

## Step 1: Start With the Platform Shape

Read:

1. [Architecture overview](../explanation/architecture-overview.md)
2. [Version 1 scope](../reference/version-1-scope.md)

Focus on the stable platform decisions:

- secure multi-tier application platform
- four-zone network model
- Proxmox Linux bridge fabric with OPNsense as the internal routing and policy control plane
- reverse-proxy-only ingress in Version 1
- one real environment under `terraform/live/prod/`

## Step 2: Learn the Boundary Model

Read:

1. [State boundaries](../explanation/state-boundaries.md)
2. [Ansible handoff](../explanation/ansible-handoff.md)
3. [Repository layout](../reference/repository-layout.md)

At this point you should be able to explain:

- why Terraform is split into three states
- why cloud-init is limited to bootstrap
- why Ansible starts after Terraform and cloud-init complete
- where future Packer implementation belongs

## Step 3: Learn the Trust Model

Read:

1. [DMZ design](../explanation/dmz-design.md)
2. [Network zones](../reference/network-zones.md)

Your working mental model should be:

- Proxmox provides L2 bridge transport, not Version 1 routing or firewall policy
- OPNsense owns zone gateways and inter-zone policy
- `edge` is semi-trusted and public-facing
- `app` and `data` are internal service zones
- `mgmt` is the administrative control plane
- public ingress terminates in `edge`, not in internal tiers

## Step 4: Learn the Delivery Sequence

Read:

1. [Implementation phases](../roadmap/implementation-phases.md)
2. [Milestones](../roadmap/milestones.md)
3. [How to plan delivery phases](../how-to/plan-delivery-phases.md)

This tells you what to build first and what each phase must prove before the next phase begins.

## Step 5: Read the ADRs Last

The ADRs are not the best entry point for a new engineer. Read them after the explanation and reference documents so the decisions have context.

Start with:

1. [ADR 0001](../adr/0001-build-secure-multi-tier-proxmox-platform.md)
2. [ADR 0002](../adr/0002-use-four-zone-network-segmentation.md)
3. [ADR 0003](../adr/0003-split-terraform-state-by-technical-layer.md)

Then continue through the remaining accepted decisions.

## Result

If you can describe the platform flow below without consulting implementation code, you are ready to contribute:

1. Packer builds the reusable image input.
2. Terraform `network` establishes Linux bridge fabric and the internal OPNsense control plane.
3. Terraform `image-factory` creates the reusable Proxmox template.
4. Terraform `workloads` provisions the platform VMs.
5. Cloud-init bootstraps host identity and static network addressing for the core Linux VMs.
6. Ansible configures the guest OS and services.
