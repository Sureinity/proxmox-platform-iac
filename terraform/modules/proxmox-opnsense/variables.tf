variable "name" {
  type        = string
  description = "Firewall VM name."

  validation {
    condition     = can(regex("^[A-Za-z0-9][A-Za-z0-9._-]{1,62}$", var.name))
    error_message = "name must be a valid Proxmox VM name."
  }
}

variable "description" {
  type        = string
  description = "Firewall VM description."
  default     = "Managed by Terraform as the internal OPNsense control plane."
}

variable "node_name" {
  type        = string
  description = "Node where the firewall VM will run."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.node_name))
    error_message = "node_name must be a valid Proxmox node name."
  }
}

variable "vm_id" {
  type        = number
  description = "Unique VM ID for the firewall appliance."

  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 999999999
    error_message = "vm_id must be between 100 and 999999999."
  }
}

variable "template_vm_id" {
  type        = number
  description = "Source template VM ID for the firewall appliance."

  validation {
    condition     = var.template_vm_id >= 100 && var.template_vm_id <= 999999999
    error_message = "template_vm_id must be between 100 and 999999999."
  }
}

variable "started" {
  type        = bool
  description = "Whether the firewall VM should be running."
  default     = true
}

variable "on_boot" {
  type        = bool
  description = "Whether the firewall VM should start with the node."
  default     = true
}

variable "cpu_cores" {
  type        = number
  description = "Firewall VM CPU cores."
  default     = 2

  validation {
    condition     = var.cpu_cores >= 1 && var.cpu_cores <= 32
    error_message = "cpu_cores must be between 1 and 32."
  }
}

variable "memory_mb" {
  type        = number
  description = "Firewall VM dedicated memory in MiB."
  default     = 4096

  validation {
    condition     = var.memory_mb >= 1024
    error_message = "memory_mb must be at least 1024."
  }
}

variable "network_interfaces" {
  type = list(object({
    role   = string
    bridge = string
    model  = optional(string, "virtio")
  }))
  description = "Ordered firewall network interfaces."

  validation {
    condition = alltrue([
      for iface in var.network_interfaces :
      can(regex("^[A-Za-z0-9._-]+$", iface.bridge))
    ])
    error_message = "Each network interface bridge must be a valid bridge name."
  }
}
