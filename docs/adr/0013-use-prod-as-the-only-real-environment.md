# ADR 0013: Use Prod as the Only Real Environment

- Status: Accepted
- Date: 2026-05-18

## Context

The selected project model has one authoritative environment layout and should avoid fake parallel environments that dilute ownership or misrepresent operational reality.

## Decision

Use `terraform/live/prod/` as the only real environment.

## Consequences

- repository layout must not introduce `dev` or `stage` as peer live environments
- naming conventions do not need to encode multiple environment tiers
- review discipline and state boundaries carry more weight because there is no lower environment abstraction in the repository model
