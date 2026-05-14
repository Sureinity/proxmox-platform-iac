variable "name" {
  type        = string
  description = "VM name."

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9._-]{1,62}$", var.name))
    error_message = "name must be a valid Proxmox VM name."
  }
}

variable "node_name" {
  type        = string
  description = "Proxmox node that runs the VM."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.node_name))
    error_message = "node_name must be a valid Proxmox node name."
  }
}

variable "vm_id" {
  type        = number
  description = "Unique Proxmox VM ID."

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 999999999
    error_message = "vm_id must be between 100 and 999999999."
  }
}

variable "template_vm_id" {
  type        = number
  description = "Source Proxmox VM template ID."

  validation {
    condition     = var.template_vm_id >= 100 && var.template_vm_id <= 999999999
    error_message = "template_vm_id must be between 100 and 999999999."
  }
}

variable "started" {
  type        = bool
  description = "Whether the VM should be running."
  default     = true
}

variable "on_boot" {
  type        = bool
  description = "Whether the VM starts when the Proxmox node boots."
  default     = true
}

variable "cpu_cores" {
  type        = number
  description = "Number of CPU cores."
  default     = 2

  validation {
    condition     = var.cpu_cores >= 1 && var.cpu_cores <= 64
    error_message = "cpu_cores must be between 1 and 64."
  }
}

variable "memory_mb" {
  type        = number
  description = "Dedicated memory in MiB."
  default     = 2048

  validation {
    condition     = var.memory_mb >= 512
    error_message = "memory_mb must be at least 512."
  }
}

variable "bridge" {
  type        = string
  description = "Bridge or VNet attached to the VM NIC."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.bridge))
    error_message = "bridge must be a valid Proxmox bridge or VNet identifier."
  }
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "Datastore used for cloud-init media."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.cloud_init_datastore_id))
    error_message = "cloud_init_datastore_id must be a valid Proxmox datastore identifier."
  }
}

variable "ipv4_address" {
  type        = string
  description = "Cloud-init IPv4 address in CIDR notation, or dhcp."

  validation {
    condition     = var.ipv4_address == "dhcp" || can(cidrhost(var.ipv4_address, 0))
    error_message = "ipv4_address must be dhcp or a valid CIDR address such as 10.0.50.10/24."
  }
}

variable "ipv4_gateway" {
  type        = string
  description = "Cloud-init IPv4 gateway. Use null when ipv4_address is dhcp."
  default     = null

  validation {
    condition     = var.ipv4_gateway == null || can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.ipv4_gateway))
    error_message = "ipv4_gateway must be null or an IPv4 address."
  }
}

variable "bootstrap_username" {
  type        = string
  description = "Initial cloud-init SSH user."

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
