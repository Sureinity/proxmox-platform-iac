# ADR 0007: Use Ansible for Guest Configuration

- Status: Accepted
- Date: 2026-05-18

## Context

The platform needs a repeatable and auditable way to configure guest operating systems after infrastructure is provisioned.

## Decision

Use Ansible for:

- packages
- users
- SSH hardening
- Docker or runtime setup
- service configs
- monitoring

## Consequences

- Terraform must not be used as a guest-configuration engine
- Ansible inventory becomes a formal handoff artifact
- guest configuration can be rerun independently from infrastructure provisioning
