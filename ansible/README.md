# Ansible

Ansible configures guest operating systems after Terraform creates reachable VMs.

## Inventory

Use `terraform/live/prod/workloads` output `ansible_inventory_hosts` to generate a local inventory from `inventories/prod/hosts.yml.example`.

Do not commit `hosts.yml`, private keys, vault files, passwords, or machine-specific group variable files.

## Baseline Role

The `baseline` role configures:

- Debian package baseline
- QEMU guest agent
- Chrony time sync
- SSH hardening
- Automation user and authorized keys
- Persistent journald
- Docker Engine only when `baseline_install_docker` is explicitly enabled

## Syntax Check

```bash
cd ansible
ansible-playbook --syntax-check playbooks/baseline.yml
```
