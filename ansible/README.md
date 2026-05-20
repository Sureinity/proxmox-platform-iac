# Ansible

Ansible configures guest operating systems after Terraform creates reachable VMs.

## Inventory

Version 1 standardizes on Terraform output `ansible_inventory` as the inventory handoff contract for generating a local inventory from `inventories/prod/hosts.yml.example`.

The expected inventory shape is:

- top-level `all`
- umbrella group `linux`
- child groups `mgmt_nodes`, `edge_proxies`, `app_nodes`, and `postgresql_nodes`

The internal OPNsense firewall VM is excluded from this baseline inventory unless appliance automation is introduced as a separate decision.

Do not commit `hosts.yml`, private keys, vault files, passwords, or machine-specific group variable files.

Generate the local inventory with:

```bash
python3 ansible/scripts/generate_inventory.py
```

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
