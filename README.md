# Proxmox Platform IaC

Enterprise-grade infrastructure-as-code reference for running Proxmox platform components with Terraform and Ansible.

This repository is intentionally split by responsibility:

- Terraform owns Proxmox infrastructure lifecycle: SDN, cloud image downloads, VM templates, and cloned VMs.
- Ansible owns guest operating system configuration after Terraform has created reachable machines.
- Documentation records state boundaries, secret injection, operating order, and handoff expectations.

## Repository Layout

```text
terraform/
  modules/                 # Reusable Terraform modules
  live/prod/               # Production state boundaries
ansible/
  inventories/prod/        # Production inventory examples and group vars examples
  playbooks/               # Operational playbooks
  roles/                   # Idempotent guest configuration roles
.github/workflows/         # Pull request validation
docs/                      # Operating model and handoff documentation
```

## State Boundaries

Production Terraform is split into independent root modules:

1. `terraform/live/prod/network`
2. `terraform/live/prod/image-factory`
3. `terraform/live/prod/workloads`

Each root module has its own state file and must be migrated to a remote backend before shared use. Backend credentials are never committed.

## Apply Order

Apply order is intentionally explicit:

1. Network stack creates Proxmox SDN primitives.
2. Image factory downloads the cloud image and creates VM templates.
3. Workloads clone VMs from templates and publish Ansible-ready outputs.
4. Ansible consumes Terraform outputs or a generated inventory and configures guest operating systems.

## Secret Injection

Secrets are supplied at runtime using environment variables, GitHub Actions secrets, SOPS, Vault, or 1Password CLI. Do not commit `.tfvars`, private keys, Proxmox API tokens, vault files, passwords, Terraform state, plans, or debug logs.

## CI Checks

CI validates Terraform formatting and root-module configuration, Ansible syntax, YAML syntax, and static security checks without requiring live Proxmox credentials.

## Documentation

Start with:

- [Operating model](docs/operating-model.md)
- [State management](docs/state-management.md)
- [Secrets management](docs/secrets-management.md)
- [Ansible handoff](docs/ansible-handoff.md)
