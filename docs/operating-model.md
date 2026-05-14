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
