# State Management

Each Terraform root module is a separate state boundary:

- `network` owns Proxmox SDN resources.
- `image-factory` owns cloud image downloads and templates.
- `workloads` owns cloned VMs.

State files must not be committed. Use a remote backend for team operation and configure backend credentials outside the repository.

Recommended backends include Terraform Cloud, S3-compatible object storage with locking, or another centrally managed backend approved by the platform team.
