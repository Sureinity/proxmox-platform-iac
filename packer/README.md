# Packer

Packer owns reusable Debian image and template construction for the platform.

## Structure

```text
packer/
  debian-13-base/
    template.pkr.hcl
    debian-13-base.pkrvars.hcl.example
    scripts/
      baseline.sh
      cleanup.sh
```

## Version 1 Scope

The accepted Version 1 image-factory boundary is:

- build the approved Debian-based Proxmox template artifact
- apply image-time configuration required for a reusable template baseline
- publish artifact metadata that Terraform can consume without rebuilding the image

The current implementation uses the Proxmox clone builder to clone a bootstrap cloud-init-enabled Debian source template and convert the result into the approved template artifact.

## Inputs

The current template expects:

- Proxmox API access through `proxmox_url`, `proxmox_username`, and `proxmox_api_token`
- a bootstrap source template name through `source_template_name`
- a bootstrap bridge, defaulting to `vmbr0`
- a cloud-init storage pool for the cloned template

Use a local `.pkrvars.hcl` copied from `debian-13-base.pkrvars.hcl.example`. Do not commit real `.pkrvars.hcl` files.

## Output Contract

The build emits a manifest file by default at:

```text
packer/debian-13-base/output/debian-13-base-manifest.json
```

That manifest is generated output and must not be committed. It is intended to provide template metadata for downstream Terraform consumption.

The manifest custom metadata is expected to include:

- `template_name`
- `template_node_name`
- `bootstrap_username`
- `template_profile`
- `build_id`

## Build Workflow

```bash
cd packer/debian-13-base
packer init .
packer fmt .
packer validate -var-file=debian-13-base.pkrvars.hcl .
packer build -var-file=debian-13-base.pkrvars.hcl .
```

## Must Not Own

Packer must not own:

- workload VM cloning
- environment-specific network addressing
- runtime application secrets
- long-lived guest service configuration that belongs in Ansible

## Current Boundary

Packer now establishes the concrete repository boundary for the image factory. Terraform under `terraform/live/prod/image-factory/` should continue to move toward consuming this artifact contract rather than building templates directly.
