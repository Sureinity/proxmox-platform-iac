# ADR 0004: Use Capability-Based Terraform Modules

- Status: Accepted
- Date: 2026-05-18

## Context

The repository needs reusable Terraform modules that reflect technical capabilities rather than environment-specific stacks.

## Decision

Use capability-based Terraform modules.

## Consequences

- module directories express reusable functions such as SDN, template, or VM creation
- environment or state-specific orchestration remains in root modules under `terraform/live/prod/`
- module naming must not encode `prod` or other environment labels
