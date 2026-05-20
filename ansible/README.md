# Ansible

Ansible configures guest operating systems after Terraform creates reachable VMs.

## Inventory

Version 1 standardizes on Terraform output `ansible_inventory` as the inventory handoff contract for generating a local inventory from `inventories/prod/hosts.yml.example`.

If local Terraform still exposes `ansible_inventory_hosts`, treat that as compatibility output during the handoff transition rather than the target contract.

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
