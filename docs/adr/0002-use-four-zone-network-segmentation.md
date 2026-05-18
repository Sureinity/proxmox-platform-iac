# ADR 0002: Use Four-Zone Network Segmentation

- Status: Accepted
- Date: 2026-05-18

## Context

The platform requires a simple but explicit network trust model for administrative access, ingress, application services, and data services.

## Decision

Use four zones with fixed subnets:

- `mgmt`: `10.0.1.0/24`
- `edge`: `10.0.2.0/24`
- `app`: `10.0.3.0/24`
- `data`: `10.0.4.0/24`

## Consequences

- every workload must be placed into one of the accepted zones
- public ingress terminates in `edge`
- internal service and data paths can be documented and enforced explicitly
