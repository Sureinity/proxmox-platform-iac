# Packer

Packer owns reusable Debian image and template construction for the platform.

## Version 1 Scope

The accepted Version 1 image-factory boundary is:

- build the approved Debian-based Proxmox template artifact
- apply image-time configuration required for a reusable template baseline
- publish artifact metadata that Terraform can consume without rebuilding the image

## Must Not Own

Packer must not own:

- workload VM cloning
- environment-specific network addressing
- runtime application secrets
- long-lived guest service configuration that belongs in Ansible

## Status

This directory establishes the repository boundary for the image factory.

Concrete Packer build definitions are not implemented in this repository yet. Until they are, any Terraform code that builds templates directly should be treated as transition-state drift to remove, not as the target platform pattern.
