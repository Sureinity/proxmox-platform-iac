# Network Zones

## Zone Definitions

| Zone | Subnet | Purpose | Trust level | Allowed ingress patterns | Allowed egress patterns |
| --- | --- | --- | --- | --- | --- |
| `mgmt` | `10.0.1.0/24` | Administrative access, automation, and operational control paths | Trusted administrative zone | Operator and automation access from approved management entry points | Administrative access to `edge`, `app`, and `data` on explicitly approved ports |
| `edge` | `10.0.2.0/24` | DMZ ingress tier for reverse proxy services | Semi-trusted DMZ | External client traffic to published reverse-proxy listeners; approved admin access from `mgmt` | Backend proxy traffic to `app`; approved operational egress only |
| `app` | `10.0.3.0/24` | Application service tier | Trusted workload zone | Reverse-proxy traffic from `edge`; approved admin access from `mgmt` | Application-to-database traffic to `data`; approved external dependencies only |
| `data` | `10.0.4.0/24` | Stateful data services such as PostgreSQL | Highly trusted restricted zone | Application traffic from `app`; approved admin and maintenance access from `mgmt` | Minimal approved egress only; no general-purpose outbound access |

## Default Trust Model

- `mgmt` is trusted for platform administration, but it is not a general-purpose workload zone.
- `edge` is semi-trusted and must be treated as exposed to untrusted traffic.
- `app` is trusted for internal application execution only.
- `data` is the most restricted zone and must not be reachable directly from public ingress paths.

## Traffic Matrix

The table below describes the intended policy baseline.

| Source | Destination | Policy | Notes |
| --- | --- | --- | --- |
| External | `edge` | Allow | Published reverse-proxy listeners only |
| External | `mgmt` | Deny | No direct public management access |
| External | `app` | Deny | No direct public application access |
| External | `data` | Deny | No direct public data access |
| `mgmt` | `edge` | Allow | SSH, automation, operational access on approved ports |
| `mgmt` | `app` | Allow | SSH, automation, operational access on approved ports |
| `mgmt` | `data` | Allow | Database administration, backup, and operational access on approved ports |
| `edge` | `app` | Allow | Reverse-proxy to application service ports only |
| `edge` | `data` | Deny | No direct DMZ-to-data path |
| `edge` | `mgmt` | Deny | No initiated DMZ-to-management trust path |
| `app` | `data` | Allow | Application-to-database service ports only |
| `app` | `edge` | Deny by default | Response traffic is handled statefully; initiated access requires review |
| `app` | `mgmt` | Deny by default | No initiated application-to-management trust path |
| `data` | `edge` | Deny | No initiated data-to-DMZ path |
| `data` | `app` | Deny by default | Response traffic only unless a reviewed exception exists |
| `data` | `mgmt` | Deny by default | No initiated data-to-management trust path |

## Version 1 Interpretation

Version 1 defines the trust and path contract even where enforcement details are still being implemented. Future Terraform network work must satisfy this matrix rather than redefining it case by case.
