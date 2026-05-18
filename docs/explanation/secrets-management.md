# Secrets Management

## Version 1 Policy

Version 1 uses environment-variable secret injection and committed `.tfvars.example` files.

This means:

- secrets are injected at runtime through environment variables
- `.tfvars.example` files document required inputs and placeholder values
- committed examples are not a substitute for secret storage
- any local file containing real secret values must remain untracked

## Approved Version 1 Pattern

Use environment variables for secret values such as:

- Proxmox API tokens
- provider credentials
- any bootstrap secrets required by future tooling

Use `.tfvars.example` files to document:

- required variable names
- expected value shape
- non-secret example values
- local file conventions for operators

Real secret values must not be committed to any `.tfvars` file.

## Explicitly Forbidden

The following are forbidden in this repository:

- hardcoded secrets in Terraform, Packer, Ansible, shell scripts, or CI workflows
- committed `.tfvars` files with real values
- committed Terraform state containing real infrastructure data
- committed private keys
- committed plaintext passwords
- committed debug logs that expose credentials or runtime context

These are policy violations, not style issues.

## Planned Migration to SOPS

Version 2 introduces SOPS for encrypted configuration material that must live alongside code.

The migration goal is:

- keep secret data encrypted at rest in the repository when versioning is required
- separate encrypted operator input from plaintext examples
- support controlled review and rotation workflows

Version 1 does not assume SOPS is available yet. Documentation and implementation should therefore avoid claiming encrypted repository-managed secrets until that migration is actually delivered.

## Operator Expectations

Version 1 operators should assume:

- secret values come from the local shell, CI environment secrets, or an external secret tool
- committed examples exist to show shape, not to hold values
- cleanup of local secret files is an operator responsibility unless automated secret tooling is added later
