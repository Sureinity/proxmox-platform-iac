# ADR 0005: Use Packer for Image Factory

- Status: Accepted
- Date: 2026-05-18

## Context

The platform needs a repeatable image creation process that is separate from runtime provisioning and guest configuration.

## Decision

Use Packer as the image-factory tool.

## Consequences

- image builds become an explicit repository concern under `packer/`
- Terraform `image-factory` consumes image outputs rather than building images itself
- runtime service configuration must not be embedded into image builds
