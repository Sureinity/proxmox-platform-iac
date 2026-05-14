# Secrets Management

Do not commit secrets or machine-specific credentials.

Recommended secret sources:

- Environment variables such as `TF_VAR_proxmox_api_token`.
- GitHub Actions secrets for CI jobs that need authenticated checks.
- SOPS for encrypted files when configuration must be versioned.
- Vault for dynamic credentials and centrally managed policy.
- 1Password CLI for local operator workflows.

Insecure TLS verification is configurable for lab environments, but production should use trusted certificates and keep TLS verification enabled.
