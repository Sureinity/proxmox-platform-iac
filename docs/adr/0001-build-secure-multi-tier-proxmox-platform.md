# ADR 0001: Build Secure Multi-Tier Proxmox Platform

- Status: Accepted
- Date: 2026-05-18

## Context

The repository is being established as an enterprise-grade platform project rather than a generic infrastructure workspace. The platform needs a clear operating model, trust boundary model, and delivery scope.

## Decision

Build the project as a secure multi-tier application platform on Proxmox.

## Consequences

- the platform is organized around explicit trust boundaries
- infrastructure, bootstrap, and guest configuration responsibilities must remain separated
- platform documentation must describe production contracts rather than experimental patterns
