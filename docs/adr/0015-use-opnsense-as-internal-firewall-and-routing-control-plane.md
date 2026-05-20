# ADR 0015: Use OPNsense as Internal Firewall and Routing Control Plane

- Status: Accepted
- Date: 2026-05-20

## Context

Version 1 needs a clear owner for zone gateways, inter-zone routing, firewall policy, and network observability.

## Decision

Use an internal OPNsense firewall VM as the Version 1 L3 and policy control plane.

OPNsense owns:

- zone gateway IPs
- inter-zone routing
- firewall policy
- logging
- DHCP only where explicitly needed
- NAT only where explicitly needed

## Consequences

- the `network` state must model the internal firewall VM as part of the platform network contract
- workload and core Linux VMs continue to use static IP assignment via cloud-init by default
- Version 1 does not require a separate Linux DHCP VM
