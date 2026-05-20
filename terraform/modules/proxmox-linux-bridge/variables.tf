variable "node_name" {
  type        = string
  description = "Proxmox node that owns the Linux bridge."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.node_name))
    error_message = "node_name must be a valid Proxmox node name."
  }
}

variable "name" {
  type        = string
  description = "Linux bridge interface name."

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]{0,9}$", var.name))
    error_message = "name must start with a letter and be at most 10 characters using letters, numbers, or underscores."
  }
}

variable "address" {
  type        = string
  description = "Optional IPv4/CIDR address for the bridge."
  default     = null
}

variable "address6" {
  type        = string
  description = "Optional IPv6/CIDR address for the bridge."
  default     = null
}

variable "autostart" {
  type        = bool
  description = "Whether the bridge should autostart on boot."
  default     = true
}

variable "comment" {
  type        = string
  description = "Optional bridge comment."
  default     = null
}

variable "gateway" {
  type        = string
  description = "Optional IPv4 gateway for the bridge."
  default     = null
}

variable "gateway6" {
  type        = string
  description = "Optional IPv6 gateway for the bridge."
  default     = null
}

variable "mtu" {
  type        = number
  description = "Bridge MTU."
  default     = 1500

  validation {
    condition     = var.mtu >= 576 && var.mtu <= 9000
    error_message = "mtu must be between 576 and 9000."
  }
}

variable "ports" {
  type        = list(string)
  description = "Host interfaces attached to the bridge."
  default     = []
}

variable "vlan_aware" {
  type        = bool
  description = "Whether the bridge is VLAN-aware."
  default     = false
}

variable "vids" {
  type        = string
  description = "Allowed VLAN IDs when vlan_aware is true."
  default     = null
}
