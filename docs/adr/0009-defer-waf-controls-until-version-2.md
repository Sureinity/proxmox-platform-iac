# ADR 0009: Defer WAF Controls Until Version 2

- Status: Accepted
- Date: 2026-05-18

## Context

The platform will eventually need stronger ingress controls, but Version 1 is focused on establishing the reverse-proxy boundary and core platform layers first.

## Decision

Defer WAF controls until Version 2.

## Consequences

- Version 1 documentation must describe reverse proxy only
- implementation work must not assume a WAF is already present
- future WAF adoption remains an explicit planned enhancement rather than hidden scope
