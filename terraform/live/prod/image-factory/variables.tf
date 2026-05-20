variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API endpoint URL."

  validation {
    condition     = can(regex("^https://", var.proxmox_endpoint))
    error_message = "proxmox_endpoint must be an HTTPS URL."
  }
}

variable "proxmox_api_token" {
  type        = string
  description = "Proxmox API token in provider-supported format."
  sensitive   = true

  validation {
    condition     = length(var.proxmox_api_token) > 0
    error_message = "proxmox_api_token must not be empty."
  }
}

variable "proxmox_insecure_tls" {
  type        = bool
  description = "Allow insecure TLS connections to Proxmox. Use only when explicitly accepting self-signed or otherwise untrusted certificates."
  default     = false
}

variable "node_name" {
  type        = string
  description = "Proxmox node for image download and template creation."
}

variable "image_datastore_id" {
  type        = string
  description = "Datastore used for downloaded cloud image imports."
}

variable "vm_datastore_id" {
  type        = string
  description = "Datastore used for template VM disks."
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "Datastore used for cloud-init media."
}

variable "image_url" {
  type        = string
  description = "HTTPS URL for the Debian cloud image."
}

variable "template_name" {
  type        = string
  description = "Name for the Debian VM template."
}

variable "template_vm_id" {
  type        = number
  description = "Proxmox VM ID for the Debian template."
}

variable "template_bridge" {
  type        = string
  description = "Bridge or VNet attached to the template NIC."
}

variable "bootstrap_username" {
  type        = string
  description = "Initial cloud-init SSH user."
}

variable "bootstrap_ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys authorized for bootstrap access."
  sensitive   = true
}

variable "template_disk_size_gb" {
  type        = number
  description = "Template disk size in GiB."
  default     = 10
}

variable "template_memory_mb" {
  type        = number
  description = "Template memory in MiB."
  default     = 1536
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers configured by cloud-init."
  default     = ["1.1.1.1", "8.8.8.8"]
}
