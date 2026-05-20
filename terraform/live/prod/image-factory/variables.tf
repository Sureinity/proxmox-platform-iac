variable "packer_manifest_path" {
  type        = string
  description = "Path to the generated Packer manifest consumed by the Terraform image-factory boundary."
  default     = "../../../../packer/debian-13-base/output/debian-13-base-manifest.json"
}
