# Ansible Handoff

Terraform workload outputs are the source for Ansible inventory.

The handoff contract is:

- Terraform creates VMs and cloud-init bootstrap users with SSH public keys.
- Terraform outputs host names, addresses, and bootstrap SSH user names.
- Operators generate or update `ansible/inventories/prod/hosts.yml` locally from those outputs.
- Ansible applies common guest configuration using idempotent roles.

Only example inventory and group variable files are committed.

## Inventory Example

Terraform publishes:

```bash
terraform -chdir=terraform/live/prod/workloads output -json ansible_inventory_hosts
```

Use that output to create a local `ansible/inventories/prod/hosts.yml` based on `hosts.yml.example`.

Example structure:

```yaml
all:
  children:
    debian_trixie:
      hosts:
        portfolio_next_js:
          ansible_host: 10.0.50.110
      vars:
        ansible_user: debian
```

## Bootstrap Expectations

Terraform cloud-init creates the bootstrap user from `bootstrap_username` and authorizes the provided SSH public keys. Ansible connects as that user, then creates the long-lived automation user configured by `baseline_automation_user`.

SSH password authentication can be disabled only after authorized keys are configured.
