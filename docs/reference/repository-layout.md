# Repository Layout

## Intended Top-Level Layout

This is the target repository structure. Some areas are planned and may not exist until the corresponding implementation phase is delivered.

```text
packer/
terraform/
ansible/
.github/
docs/
```

## Ownership Boundaries

| Area | Owns | Must not own |
| --- | --- | --- |
| `packer/` | Image build definitions, template build inputs, image versioning metadata | Environment-specific networking, live VM lifecycle, guest runtime configuration |
| `terraform/` | Proxmox infrastructure lifecycle, shared networking, template integration, workload VM provisioning | Guest package installation, service configuration, ad hoc bootstrap scripts that duplicate Ansible |
| `ansible/` | Guest OS baseline, users, SSH hardening, runtimes, workload service configuration, monitoring hooks | VM creation, Proxmox SDN resources, template creation, secret storage in plaintext |
| `.github/` | Validation-only CI workflows and repository automation | Direct infrastructure apply workflows in Version 1, embedded long-lived credentials |
| `docs/` | Diataxis documentation, ADRs, roadmap, project contracts | Implementation logic, generated runtime state, operator secrets |

## Terraform Layout Contract

The Terraform area is expected to remain structured as:

```text
terraform/
  modules/
    <capability-modules>/
  live/
    prod/
      network/
      image-factory/
      workloads/
```

Rules:

- `modules/` contains reusable capability modules only
- `live/prod/` contains the only real environment
- root modules under `live/prod/` map directly to the accepted state boundaries

## Packer Layout Contract

The Packer area is planned to hold the image-factory implementation.

Expected ownership:

- base image definition
- builder configuration
- provisioners limited to image build concerns
- artifact metadata needed by Terraform `image-factory`

Expected non-ownership:

- runtime workload secrets
- environment-specific VM definitions
- post-provision guest service configuration

## Ansible Layout Contract

The Ansible area is expected to remain structured around:

- `inventories/prod/`
- `playbooks/`
- `roles/`

Inventory content is derived from Terraform outputs in Version 1. Only examples or generated local files should exist under version control where explicitly allowed by policy.

## Documentation Layout Contract

The `docs/` tree uses Diataxis:

- explanations describe why the platform is shaped this way
- reference defines stable contracts and rules
- how-to guides explain specific project tasks
- tutorials orient engineers to the platform
- ADRs record accepted architecture decisions
- roadmap documents sequence the delivery work
