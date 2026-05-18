# Architecture Overview

## Platform Goal

The platform is a secure multi-tier application platform on Proxmox. It provides a controlled network boundary model, an immutable image pipeline, infrastructure lifecycle management, and guest operating system configuration for the first production platform workloads.

Version 1 is centered on three workload VMs:

- Traefik reverse proxy in the `edge` zone
- Application VM in the `app` zone
- PostgreSQL VM in the `data` zone

A monitoring VM is a planned extension and is not part of Version 1 delivery.

## System Boundaries

The platform includes:

- Proxmox SDN networking for `mgmt`, `edge`, `app`, and `data`
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

Packer owns immutable image construction. It produces the base image artifact and template inputs that the rest of the platform consumes. It must not own environment-specific networking, runtime secrets, or service-specific configuration.

### Terraform Network State

The `network` state owns shared Proxmox networking primitives. It defines the four-zone segmentation model and the routing or policy boundaries that other platform layers depend on.

### Terraform Image Factory State

The `image-factory` state imports Packer output into Proxmox and creates reusable VM templates. It exists to separate template lifecycle from both networking and workload provisioning.

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

1. Packer builds the reusable guest template input.
2. Terraform provisions the network layer.
3. Terraform provisions the workload layer, using the image-factory outputs as template inputs.
4. Cloud-init bootstraps instance identity and networking on first boot.
5. Ansible configures the guest OS and workload services.

In practice, the image-factory state sits between steps 1 and 3. Packer builds the image, and Terraform `image-factory` turns that image into a Proxmox template before the `workloads` state clones VMs from it.

## Design Constraints

- The `edge` zone is the DMZ and is semi-trusted, not trusted.
- Version 1 ingress is reverse proxy only.
- Version 1 secrets use environment variables and committed `.tfvars.example` files only.
- The only real environment layout is `terraform/live/prod/`.
- CI validates formatting, syntax, and configuration safety, but does not apply infrastructure.
