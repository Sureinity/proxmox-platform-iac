# ADR 0008: Use Traefik as Edge Reverse Proxy

- Status: Accepted
- Date: 2026-05-18

## Context

Version 1 requires a single ingress component in the DMZ to terminate and route published traffic into the internal application tier.

## Decision

Use Traefik as the Version 1 edge reverse proxy.

## Consequences

- the `edge` zone will host a Traefik VM as the primary ingress workload
- public traffic enters the platform through the reverse proxy rather than directly to application VMs
- future ingress hardening will build around this boundary
