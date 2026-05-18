# Generate Ansible Inventory

## Goal

Use Terraform workload outputs to derive the Version 1 Ansible inventory.

This document describes the intended contract. It does not claim that the final helper command or output implementation already exists.

## Version 1 Contract

The `terraform/live/prod/workloads` root module is expected to expose a stable Terraform output named `ansible_inventory`.

That output should contain the data needed to render `ansible/inventories/prod/hosts.yml` without manual host-by-host editing.

## Expected Workflow

The intended operator flow is:

1. Apply the `workloads` state.
2. Read the `ansible_inventory` Terraform output.
3. Render that output into `ansible/inventories/prod/hosts.yml`.
4. Run Ansible against the generated inventory.

## Placeholder Command Pattern

Until a repo-local helper command is implemented, use this as the target command pattern:

```bash
terraform -chdir=terraform/live/prod/workloads output -json ansible_inventory
```

One acceptable future implementation is a wrapper that renders the JSON contract directly to YAML, for example:

```bash
terraform -chdir=terraform/live/prod/workloads output -json ansible_inventory \
  | <renderer> > ansible/inventories/prod/hosts.yml
```

`<renderer>` is intentionally a placeholder. It may become a small repository script, a Make target, or a documented `jq` and `yq` pipeline during the inventory hardening phase.

## Expected Data Shape

The target output should be renderable into a standard Ansible inventory shape such as:

```yaml
all:
  children:
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

## Current State Note

If the current implementation exposes a different output name or shape, treat that as implementation drift to be corrected during the workload and handoff phases. The accepted Version 1 contract remains `ansible_inventory`.
