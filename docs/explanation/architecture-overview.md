# Architecture Overview

## Platform Goal

The platform is a secure multi-tier application platform on Proxmox. It provides a controlled network boundary model, an immutable image pipeline, infrastructure lifecycle management, and guest operating system configuration for the first production platform workloads.

Version 1 includes the internal firewall control plane and four core guest VMs:

- OPNsense internal firewall VM as the routing and policy control plane
- operator-facing admin or jump VM in the `mgmt` zone
- Traefik reverse proxy in the `edge` zone
- application VM in the `app` zone
- PostgreSQL VM in the `data` zone

A monitoring VM is a planned extension and is not part of Version 1 delivery.

## System Boundaries

The platform includes:

- Proxmox Linux bridge fabric for `mgmt`, `edge`, `app`, and `data`
- internal OPNsense firewall control plane for routing, policy, and gateway ownership
- Packer-based image creation for reusable guest templates
- Terraform state layers for network, image factory, and workloads
- Cloud-init for first-boot identity and network bootstrap
- Ansible for guest operating system and service configuration
- Validation-only CI workflows for repository quality gates

The platform excludes from Version 1:

- Web application firewall controls
- SOPS-based secret management
- Dynamic Ansible inventory
- Additional non-production environments

## Component Responsibilities

### Packer Image Factory

Packer owns immutable image and template construction. It produces the approved Proxmox template artifact and metadata that the rest of the platform consumes. It must not own environment-specific networking, runtime secrets, or service-specific configuration.

### Terraform Network State

The `network` state owns the shared Proxmox Linux bridge fabric and the internal firewall control-plane contract. It defines bridge attachments, zone gateway definitions, and the policy contract that downstream platform layers depend on.

### OPNsense Control Plane

OPNsense is the Version 1 L3 and policy control plane.

It owns:

- zone gateway IPs
- inter-zone routing
- firewall policy
- logging
- DHCP only where explicitly needed
- NAT only where explicitly needed

Proxmox does not own those L3 or policy functions in Version 1. Proxmox provides only the virtual switching and attachment fabric.

### Terraform Image Factory State

The `image-factory` state is the Terraform-side integration boundary for approved Packer outputs. It exists to separate template contract management from both networking and workload provisioning. It must not become a second image builder.

### Terraform Workloads State

The `workloads` state creates the Version 1 platform VMs and publishes the inventory handoff contract for Ansible. It owns infrastructure lifecycle only. It must not perform guest configuration.

### Cloud-init

Cloud-init is limited to bootstrap concerns:

- hostname
- SSH user
- SSH keys
- network

Cloud-init must not become a second configuration-management system.

### Ansible

Ansible owns guest OS and service configuration:

- packages
- users
- SSH hardening
- Docker or container runtime
- service configs
- monitoring hooks

Ansible begins only after Terraform has created reachable VMs with the expected bootstrap identity.

## Operating Flow

The platform operating flow is:

1. Packer builds the reusable Debian template artifact.
2. Terraform provisions the network layer, including Linux bridge fabric and the internal OPNsense control-plane contract.
3. Terraform `image-factory` publishes or consumes the approved template contract needed by downstream Terraform.
4. Terraform provisions the workload layer, using that template contract as input.
5. Cloud-init bootstraps instance identity and networking on first boot, using static IP assignment as the default for core Linux VMs.
6. Ansible configures the guest OS and workload services.

Current implementation note: some Terraform in `terraform/live/prod/image-factory/` still reflects pre-Packer-transition template construction. Treat that as implementation drift to remove, not as the accepted platform boundary.

## Design Constraints

- The `edge` zone is the DMZ and is semi-trusted, not trusted.
- Proxmox Linux bridges provide L2 transport only in Version 1.
- OPNsense owns zone gateways, routing, policy, and optional DHCP or NAT behavior.
- Version 1 ingress is reverse proxy only.
- Static addressing via cloud-init is the default for core infrastructure and workload VMs.
- DHCP is optional and, when used, is owned by OPNsense rather than a separate Linux DHCP VM.
- Version 1 secrets use environment variables and committed `.tfvars.example` files only.
- The only real environment layout is `terraform/live/prod/`.
- CI validates formatting, syntax, and configuration safety, but does not apply infrastructure.
