# Operating Model

This repository separates platform lifecycle concerns from guest operating system configuration.

Terraform manages Proxmox infrastructure resources only. Ansible configures the operating system after Terraform has created reachable VMs.

The production flow is:

1. Apply `terraform/live/prod/network`.
2. Apply `terraform/live/prod/image-factory`.
3. Apply `terraform/live/prod/workloads`.
4. Generate or update Ansible inventory from workload outputs.
5. Run Ansible baseline playbooks.

Terraform provisioners are intentionally not used for Ansible execution.

## Responsibility Matrix

| Area | Terraform | Ansible |
| --- | --- | --- |
| Proxmox SDN zone, VNet, subnet, DHCP, SNAT | Yes | No |
| Cloud image download | Yes | No |
| VM template lifecycle | Yes | No |
| Cloned VM lifecycle | Yes | No |
| Package baseline | No | Yes |
| SSH daemon hardening | No | Yes |
| Automation user management | No | Yes |
| Application deployment | No | Separate role or repository |

## Operator Flow

Use explicit review gates between state boundaries:

```bash
terraform -chdir=terraform/live/prod/network init
terraform -chdir=terraform/live/prod/network plan
terraform -chdir=terraform/live/prod/network apply

terraform -chdir=terraform/live/prod/image-factory init
terraform -chdir=terraform/live/prod/image-factory plan
terraform -chdir=terraform/live/prod/image-factory apply

terraform -chdir=terraform/live/prod/workloads init
terraform -chdir=terraform/live/prod/workloads plan
terraform -chdir=terraform/live/prod/workloads apply

terraform -chdir=terraform/live/prod/workloads output -json ansible_inventory_hosts
cd ansible
ansible-playbook playbooks/baseline.yml
```

Do not run Ansible from Terraform provisioners. Keep convergence failures visible in Ansible logs instead of hiding them inside Terraform apply output.
