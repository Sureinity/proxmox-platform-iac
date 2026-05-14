# State Management

Each Terraform root module is a separate state boundary:

- `network` owns Proxmox SDN resources.
- `image-factory` owns cloud image downloads and templates.
- `workloads` owns cloned VMs.

State files must not be committed. Use a remote backend for team operation and configure backend credentials outside the repository.

Recommended backends include Terraform Cloud, S3-compatible object storage with locking, or another centrally managed backend approved by the platform team.

## Backend Stubs

Backend blocks are intentionally not committed because backend settings often contain organization-specific bucket names, workspace IDs, endpoints, or credential assumptions.

For a shared S3-compatible backend, an operator can add a local backend file during migration:

```hcl
terraform {
  backend "s3" {
    bucket         = "example-terraform-state"
    key            = "proxmox-platform/prod/network.tfstate"
    region         = "us-east-1"
    dynamodb_table = "example-terraform-locks"
    encrypt        = true
  }
}
```

Then run:

```bash
terraform init -migrate-state
```

Never commit backend credentials. Prefer workload identity, environment variables, or short-lived credentials.

## State Movement

Do not manually copy state files between roots. If ownership changes, use reviewed `terraform state mv` commands and commit the matching code change separately.
