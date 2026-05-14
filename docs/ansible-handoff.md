# Ansible Handoff

Terraform workload outputs are the source for Ansible inventory.

The handoff contract is:

- Terraform creates VMs and cloud-init bootstrap users with SSH public keys.
- Terraform outputs host names, addresses, and bootstrap SSH user names.
- Operators generate or update `ansible/inventories/prod/hosts.yml` locally from those outputs.
- Ansible applies common guest configuration using idempotent roles.

Only example inventory and group variable files are committed.
