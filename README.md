# Proxmox Platform IaC

Enterprise-grade infrastructure-as-code reference for running Proxmox platform components with Terraform and Ansible.

The repository is being shaped into a secure multi-tier application platform on Proxmox. It preserves the core project intent of segmented networking, reusable image and template handling, cloned VM provisioning, and guest baseline configuration.

Repository policy forbids committed state files, real `.tfvars`, private keys, plaintext secrets, and similar local artifacts. Implementation cleanup and enforcement must continue to align the working tree with that policy.

This repository is intentionally split by responsibility:

- Terraform owns Proxmox infrastructure lifecycle: SDN, cloud image downloads, VM templates, and cloned VMs.
- Ansible owns guest operating system configuration after Terraform has created reachable machines.
- Documentation records state boundaries, secret injection, operating order, and handoff expectations.

## Repository Layout

```text
packer/                     # Planned image build pipeline
terraform/
  modules/                 # Reusable Terraform modules
  live/prod/               # Production state boundaries
ansible/
  inventories/prod/        # Production inventory examples and group vars examples
  playbooks/               # Operational playbooks
  roles/                   # Idempotent guest configuration roles
.github/workflows/         # Pull request validation
docs/                      # Diataxis documentation, ADRs, and roadmap
```

## State Boundaries

Production Terraform is split into independent root modules:

1. `terraform/live/prod/network`
2. `terraform/live/prod/image-factory`
3. `terraform/live/prod/workloads`

Each root module has its own state file and must be migrated to a remote backend before shared use. Backend credentials are never committed.

Terraform root modules do not call each other directly. Operators pass required outputs between state boundaries through reviewed variables, remote state data sources added by the operator, or an approved orchestration workflow.

## Apply Order

Apply order is intentionally explicit:

1. Network stack creates Proxmox SDN primitives.
2. Image factory downloads the cloud image and creates VM templates.
3. Workloads clone VMs from templates and publish Ansible-ready outputs.
4. Ansible consumes Terraform outputs or a generated inventory and configures guest operating systems.

## Secret Injection

Secrets are supplied at runtime using environment variables, GitHub Actions secrets, SOPS, Vault, or 1Password CLI. Do not commit `.tfvars`, private keys, Proxmox API tokens, vault files, passwords, Terraform state, plans, or debug logs.

Common Terraform runtime inputs:

```bash
export TF_VAR_proxmox_api_token="user@realm!token-id=token-secret"
terraform -chdir=terraform/live/prod/network plan
```

Each root module includes a `terraform.tfvars.example` file. Copy it locally to `terraform.tfvars`, replace placeholders, and keep the real file untracked.

## Ansible Handoff

Run Terraform first, then generate or update a local Ansible inventory from the `terraform/live/prod/workloads` inventory output contract. The target Version 1 contract is `ansible_inventory`; implementation alignment is documented under `docs/`.

## CI Checks

CI validates Terraform formatting and root-module configuration, Ansible syntax, YAML syntax, and static security checks without requiring live Proxmox credentials.

Pull request checks intentionally use backend-disabled Terraform initialization and example Ansible inventory files. Authenticated plans and applies belong in protected deployment workflows with environment approvals.

## Documentation

Start with:

- [Documentation index](docs/README.md)
- [Architecture overview](docs/explanation/architecture-overview.md)
- [State boundaries](docs/explanation/state-boundaries.md)
- [Secrets management](docs/explanation/secrets-management.md)
- [Ansible handoff](docs/explanation/ansible-handoff.md)
