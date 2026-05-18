# ADR 0012: Use Validation-Only CI for Version 1

- Status: Accepted
- Date: 2026-05-18

## Context

The repository needs automated validation, but Version 1 should not couple pull requests to live infrastructure apply workflows.

## Decision

Use validation-only GitHub Actions in Version 1.

## Consequences

- CI focuses on formatting, linting, syntax checks, validation, and static security scanning
- pull request workflows do not require live Proxmox credentials to perform applies
- deployment automation can be introduced later as a separate decision
