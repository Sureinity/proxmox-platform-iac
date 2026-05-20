# Generate Ansible Inventory

## Goal

Use Terraform workload outputs to derive the Version 1 Ansible inventory.

This document describes the implemented Version 1 handoff contract and the repo-local command that renders it.

## Version 1 Contract

The `terraform/live/prod/workloads` root module is expected to expose a stable Terraform output named `ansible_inventory`.

That output should contain the data needed to render `ansible/inventories/prod/hosts.yml` without manual host-by-host editing.

## Expected Workflow

The operator flow is:

1. Apply the `workloads` state.
2. Run the repository inventory generator.
3. Review the generated `ansible/inventories/prod/hosts.yml`.
4. Run Ansible against the generated inventory.

## Generation Command

Use:

```bash
python3 ansible/scripts/generate_inventory.py
```

The script shells out to:

```bash
terraform -chdir=terraform/live/prod/workloads output -json ansible_inventory
```

and writes the rendered inventory to:

```text
ansible/inventories/prod/hosts.yml
```

## Expected Data Shape

The target output should be renderable into a standard Ansible inventory shape such as:

```yaml
all:
  children:
    linux:
      children:
        mgmt_nodes:
          hosts:
            prod-admin-01:
              ansible_host: 10.0.1.10
              ansible_user: platform
        edge_proxies:
          hosts:
            prod-traefik-01:
              ansible_host: 10.0.2.10
              ansible_user: platform
        app_nodes:
          hosts:
            prod-app-01:
              ansible_host: 10.0.3.10
              ansible_user: platform
        postgresql_nodes:
          hosts:
            prod-postgres-01:
              ansible_host: 10.0.4.10
              ansible_user: platform
```

The exact host addresses above are illustrative. The stable part of the contract is the output name, grouping model, and renderable structure.

The internal OPNsense firewall VM is not assumed to be part of this general Linux guest inventory contract unless a separate appliance-management decision is made.
