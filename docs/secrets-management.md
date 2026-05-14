# Secrets Management

Do not commit secrets or machine-specific credentials.

Recommended secret sources:

- Environment variables such as `TF_VAR_proxmox_api_token`.
- GitHub Actions secrets for CI jobs that need authenticated checks.
- SOPS for encrypted files when configuration must be versioned.
- Vault for dynamic credentials and centrally managed policy.
- 1Password CLI for local operator workflows.

Insecure TLS verification is configurable for lab environments, but production should use trusted certificates and keep TLS verification enabled.

## Terraform

Sensitive Terraform variables include:

- `proxmox_api_token`
- `bootstrap_ssh_public_keys`

SSH public keys are not private secrets, but they are marked sensitive in Terraform to avoid noisy plan output and reduce accidental disclosure of operator identity metadata.

Preferred local workflow:

```bash
export TF_VAR_proxmox_api_token="$(op read op://Platform/Proxmox/token)"
terraform -chdir=terraform/live/prod/workloads plan
```

## Ansible

Do not commit:

- `ansible/inventories/prod/hosts.yml`
- non-example group vars
- private SSH keys
- Ansible Vault files
- plaintext passwords

Use encrypted variable sources only when a role genuinely needs secrets. The current baseline role should operate without passwords.

## GitHub Actions

Pull request validation does not require Proxmox credentials. Protected deployment workflows, if added later, should read Proxmox API tokens from GitHub Actions environment secrets and require approval before apply.
