# Network Zones

## Fabric Baseline

Version 1 uses Proxmox Linux bridges as the L2 transport fabric.

| Bridge | Role | Notes |
| --- | --- | --- |
| `vmbr0` | Upstream transit or WAN | Connects OPNsense to the upstream network |
| `vmbr10` | `mgmt` transport | Carries the management zone |
| `vmbr20` | `edge` transport | Carries the DMZ ingress zone |
| `vmbr30` | `app` transport | Carries the application zone |
| `vmbr40` | `data` transport | Carries the database zone |

Proxmox owns only this virtual switching and attachment fabric in Version 1.

## OPNsense Gateway Ownership

OPNsense is the L3 and policy control plane for all Version 1 zones.

| Zone | Gateway owned by OPNsense |
| --- | --- |
| `mgmt` | `10.0.1.1/24` |
| `edge` | `10.0.2.1/24` |
| `app` | `10.0.3.1/24` |
| `data` | `10.0.4.1/24` |

OPNsense owns:

- zone gateway IPs
- inter-zone routing
- firewall policy
- logging
- DHCP only where explicitly needed
- NAT only where explicitly needed

Static IP assignment via cloud-init remains the default for core infrastructure and workload VMs.

## Zone Definitions

| Zone | Bridge | Subnet | Purpose | Trust level | Allowed ingress patterns | Allowed egress patterns |
| --- | --- | --- | --- | --- | --- | --- |
| `mgmt` | `vmbr10` | `10.0.1.0/24` | Administrative access, automation, and operator-facing access such as an admin or jump VM | Trusted administrative zone | Approved management access only | Required SSH, admin, and monitoring access to `edge`, `app`, and `data` |
| `edge` | `vmbr20` | `10.0.2.0/24` | DMZ ingress tier for Traefik and other public-facing entry points | Semi-trusted DMZ | Upstream ingress only on intended published ports such as `80` and `443`; approved admin access from `mgmt` | Reverse-proxy upstream traffic to `app` only |
| `app` | `vmbr30` | `10.0.3.0/24` | Application service tier | Trusted workload zone | Reverse-proxy traffic from `edge`; approved admin access from `mgmt` | PostgreSQL traffic to `data` on `5432`; approved external dependencies only when explicitly required |
| `data` | `vmbr40` | `10.0.4.0/24` | Stateful data services such as PostgreSQL | Highly trusted restricted zone | Application traffic from `app` on `5432`; approved admin and maintenance access from `mgmt` | Minimal approved egress only |

## Default Trust Model

- `mgmt` is trusted for platform administration, but it is not a general-purpose workload zone.
- `edge` is semi-trusted and must be treated as exposed to untrusted traffic.
- `app` is trusted for internal application execution only.
- `data` is the most restricted zone and must not be reachable directly from public ingress paths.

## Traffic Matrix

The table below describes the intended policy baseline.

| Source | Destination | Policy | Notes |
| --- | --- | --- | --- |
| Upstream LAN or Internet | `edge` | Allow | Intended ingress only, typically `80` and `443` through OPNsense policy and NAT where required |
| Upstream LAN or Internet | `mgmt` | Deny | No direct public management exposure |
| Upstream LAN or Internet | `app` | Deny | No direct public application exposure |
| Upstream LAN or Internet | `data` | Deny | No direct public data exposure |
| `mgmt` | `edge` | Allow | Required SSH, admin, and monitoring access only |
| `mgmt` | `app` | Allow | Required SSH, admin, and monitoring access only |
| `mgmt` | `data` | Allow | Required SSH, admin, and monitoring access only |
| `edge` | `app` | Allow | Reverse-proxy upstream traffic only |
| `edge` | `data` | Deny | No direct DMZ-to-data path |
| `edge` | `mgmt` | Deny | No initiated DMZ-to-management trust path |
| `app` | `data` | Allow | PostgreSQL `5432` only |
| `app` | `edge` | Deny by default | Response traffic is handled statefully; initiated access requires review |
| `app` | `mgmt` | Deny by default | No initiated application-to-management trust path |
| `data` | `edge` | Deny | No initiated data-to-DMZ path |
| `data` | `app` | Deny by default | Response traffic only unless a reviewed exception exists |
| `data` | `mgmt` | Deny by default | No initiated data-to-management trust path |
| Any other path | Any other path | Deny by default | Explicit exceptions must be documented and reviewed |

## Version 1 Interpretation

Version 1 defines the trust and path contract even where enforcement details are still being implemented. Future Terraform network work must satisfy this matrix using Linux bridge fabric at L2 and OPNsense as the routing and policy control plane.
