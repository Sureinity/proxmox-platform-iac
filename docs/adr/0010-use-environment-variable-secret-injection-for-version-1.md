# ADR 0010: Use Environment Variable Secret Injection for Version 1

- Status: Accepted
- Date: 2026-05-18

## Context

The platform needs a simple and defensible Version 1 secret-handling model without introducing encrypted repository-managed secret files yet.

## Decision

Use environment-variable secret injection for Version 1 and commit `.tfvars.example` files only as input documentation.

## Consequences

- real secret values are injected at runtime rather than committed
- committed examples document variable shape but do not hold secrets
- migration to SOPS remains a Version 2 concern
