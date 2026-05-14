variable "zone_id" {
  type        = string
  description = "Proxmox SDN zone identifier."

  validation {
    condition     = can(regex("^[a-z][a-z0-9_-]{1,31}$", var.zone_id))
    error_message = "zone_id must start with a lowercase letter and contain only lowercase letters, numbers, underscores, or hyphens."
  }
}

variable "vnet_id" {
  type        = string
  description = "Proxmox SDN VNet identifier."

  validation {
    condition     = can(regex("^[a-z][a-z0-9_-]{1,31}$", var.vnet_id))
    error_message = "vnet_id must start with a lowercase letter and contain only lowercase letters, numbers, underscores, or hyphens."
  }
}

variable "node_names" {
  type        = list(string)
  description = "Proxmox nodes where the SDN zone is available."

  validation {
    condition     = length(var.node_names) > 0 && alltrue([for node in var.node_names : can(regex("^[A-Za-z0-9._-]+$", node))])
    error_message = "node_names must contain at least one valid Proxmox node name."
  }
}

variable "ipam" {
  type        = string
  description = "Proxmox SDN IPAM backend."
  default     = "pve"

  validation {
    condition     = contains(["pve"], var.ipam)
    error_message = "ipam must be pve."
  }
}

variable "dhcp" {
  type        = string
  description = "Proxmox SDN DHCP backend."
  default     = "dnsmasq"

  validation {
    condition     = contains(["dnsmasq"], var.dhcp)
    error_message = "dhcp must be dnsmasq."
  }
}

variable "mtu" {
  type        = number
  description = "VNet MTU."
  default     = 1500

  validation {
    condition     = var.mtu >= 576 && var.mtu <= 9000
    error_message = "mtu must be between 576 and 9000."
  }
}

variable "subnet_cidr" {
  type        = string
  description = "CIDR block assigned to the SDN subnet."

  validation {
    condition     = can(cidrhost(var.subnet_cidr, 0))
    error_message = "subnet_cidr must be a valid IPv4 or IPv6 CIDR."
  }
}

variable "gateway" {
  type        = string
  description = "Gateway address for the SDN subnet."

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.gateway))
    error_message = "gateway must be an IPv4 address."
  }
}

variable "enable_snat" {
  type        = bool
  description = "Whether Proxmox SDN SNAT is enabled for the subnet."
  default     = true
}

variable "dhcp_start_address" {
  type        = string
  description = "DHCP range start address for the SDN subnet."

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.dhcp_start_address))
    error_message = "dhcp_start_address must be an IPv4 address."
  }
}

variable "dhcp_end_address" {
  type        = string
  description = "DHCP range end address for the SDN subnet."

  validation {
    condition     = can(regex("^([0-9]{1,3}\\.){3}[0-9]{1,3}$", var.dhcp_end_address))
    error_message = "dhcp_end_address must be an IPv4 address."
  }
}
