variable "template_name" {
  type        = string
  description = "Name of the Proxmox VM template."

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9._-]{1,62}$", var.template_name))
    error_message = "template_name must be a valid Proxmox VM name."
  }
}

variable "node_name" {
  type        = string
  description = "Proxmox node where the template is created."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.node_name))
    error_message = "node_name must be a valid Proxmox node name."
  }
}

variable "vm_id" {
  type        = number
  description = "Unique Proxmox VM ID for the template."

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 999999999
    error_message = "vm_id must be between 100 and 999999999."
  }
}

variable "bios" {
  type        = string
  description = "Template BIOS type."
  default     = "seabios"

  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "bios must be seabios or ovmf."
  }
}

variable "cloud_image_file_id" {
  type        = string
  description = "Proxmox file ID for the imported cloud image."

  validation {
    condition     = length(var.cloud_image_file_id) > 0
    error_message = "cloud_image_file_id must not be empty."
  }
}

variable "vm_datastore_id" {
  type        = string
  description = "Datastore for VM disks."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.vm_datastore_id))
    error_message = "vm_datastore_id must be a valid Proxmox datastore identifier."
  }
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "Datastore for cloud-init media."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.cloud_init_datastore_id))
    error_message = "cloud_init_datastore_id must be a valid Proxmox datastore identifier."
  }
}

variable "disk_size_gb" {
  type        = number
  description = "Template disk size in GiB."
  default     = 10

  validation {
    condition     = var.disk_size_gb >= 8
    error_message = "disk_size_gb must be at least 8."
  }
}

variable "memory_mb" {
  type        = number
  description = "Template memory in MiB."
  default     = 1536

  validation {
    condition     = var.memory_mb >= 512
    error_message = "memory_mb must be at least 512."
  }
}

variable "bridge" {
  type        = string
  description = "Network bridge or VNet used by the template NIC."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.bridge))
    error_message = "bridge must be a valid Proxmox bridge or VNet identifier."
  }
}

variable "bootstrap_username" {
  type        = string
  description = "Initial cloud-init user created for SSH bootstrap."

  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]{0,31}$", var.bootstrap_username))
    error_message = "bootstrap_username must be a valid Linux username."
  }
}

variable "bootstrap_ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys authorized for the bootstrap user."
  sensitive   = true

  validation {
    condition     = length(var.bootstrap_ssh_public_keys) > 0 && alltrue([for key in var.bootstrap_ssh_public_keys : can(regex("^ssh-(rsa|ed25519) ", key))])
    error_message = "bootstrap_ssh_public_keys must contain at least one OpenSSH public key."
  }
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers configured by cloud-init."
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "cloud_init_upgrade" {
  type        = bool
  description = "Whether cloud-init should upgrade packages on first boot."
  default     = false
}
