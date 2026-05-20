# ADR 0014: Use Linux Bridge Fabric Instead of Proxmox SDN for Version 1

- Status: Accepted
- Date: 2026-05-20

## Context

Earlier repository documentation assumed Proxmox SDN would provide the Version 1 network mechanism. That assumption no longer matches the accepted platform design.

## Decision

Use Proxmox Linux bridges as the Version 1 L2 transport fabric instead of Proxmox SDN.

The Version 1 baseline is:

- `vmbr0` for upstream transit or WAN
- `vmbr10` for `mgmt`
- `vmbr20` for `edge`
- `vmbr30` for `app`
- `vmbr40` for `data`

## Consequences

- this supersedes earlier project assumptions that Proxmox SDN would be the Version 1 segmentation mechanism
- Proxmox provides only virtual switching and attachment fabric in Version 1
- routing, gateway ownership, and policy control must be implemented outside Proxmox SDN
