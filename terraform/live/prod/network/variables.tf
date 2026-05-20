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
  description = "Proxmox API token in provider-supported format. Prefer TF_VAR_proxmox_api_token or a secret manager."
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
  description = "Primary Proxmox node for the bridge fabric and internal firewall VM."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.node_name))
    error_message = "node_name must be a valid Proxmox node name."
  }
}

variable "bridge_fabric" {
  type = map(object({
    name       = string
    comment    = optional(string)
    ports      = optional(list(string), [])
    mtu        = optional(number, 1500)
    vlan_aware = optional(bool, false)
    vids       = optional(string)
    autostart  = optional(bool, true)
  }))
  description = "Linux bridge fabric keyed by logical role."

  default = {
    upstream = {
      name    = "vmbr0"
      comment = "Upstream transit or WAN bridge"
      ports   = []
    }
    mgmt = {
      name    = "vmbr10"
      comment = "Management bridge"
      ports   = []
    }
    edge = {
      name    = "vmbr20"
      comment = "DMZ ingress bridge"
      ports   = []
    }
    app = {
      name    = "vmbr30"
      comment = "Application bridge"
      ports   = []
    }
    data = {
      name    = "vmbr40"
      comment = "Data bridge"
      ports   = []
    }
  }

  validation {
    condition = alltrue([
      contains(keys(var.bridge_fabric), "upstream"),
      contains(keys(var.bridge_fabric), "mgmt"),
      contains(keys(var.bridge_fabric), "edge"),
      contains(keys(var.bridge_fabric), "app"),
      contains(keys(var.bridge_fabric), "data"),
    ])
    error_message = "bridge_fabric must include upstream, mgmt, edge, app, and data keys."
  }
}

variable "zone_gateways" {
  type = object({
    mgmt = string
    edge = string
    app  = string
    data = string
  })
  description = "Gateway CIDR addresses owned by OPNsense for each platform zone."

  default = {
    mgmt = "10.0.1.1/24"
    edge = "10.0.2.1/24"
    app  = "10.0.3.1/24"
    data = "10.0.4.1/24"
  }

  validation {
    condition = alltrue([
      can(cidrhost(var.zone_gateways.mgmt, 0)),
      can(cidrhost(var.zone_gateways.edge, 0)),
      can(cidrhost(var.zone_gateways.app, 0)),
      can(cidrhost(var.zone_gateways.data, 0)),
    ])
    error_message = "zone_gateways values must be valid IPv4 CIDR addresses."
  }
}

variable "opnsense_name" {
  type        = string
  description = "Name of the internal OPNsense firewall VM."
  default     = "prod-opnsense-01"
}

variable "opnsense_vm_id" {
  type        = number
  description = "VM ID of the internal OPNsense firewall appliance."

  validation {
    condition     = var.opnsense_vm_id >= 100 && var.opnsense_vm_id <= 999999999
    error_message = "opnsense_vm_id must be between 100 and 999999999."
  }
}

variable "opnsense_template_vm_id" {
  type        = number
  description = "Template VM ID used to clone the internal OPNsense firewall appliance."

  validation {
    condition     = var.opnsense_template_vm_id >= 100 && var.opnsense_template_vm_id <= 999999999
    error_message = "opnsense_template_vm_id must be between 100 and 999999999."
  }
}

variable "opnsense_cpu_cores" {
  type        = number
  description = "CPU cores assigned to the internal OPNsense firewall."
  default     = 2
}

variable "opnsense_memory_mb" {
  type        = number
  description = "Dedicated memory assigned to the internal OPNsense firewall in MiB."
  default     = 4096
}

variable "opnsense_started" {
  type        = bool
  description = "Whether the internal OPNsense firewall should be started."
  default     = true
}

variable "opnsense_on_boot" {
  type        = bool
  description = "Whether the internal OPNsense firewall should start on node boot."
  default     = true
}

variable "opnsense_dhcp_zones" {
  type        = set(string)
  description = "Zones where OPNsense will provide DHCP in Version 1, if any."
  default     = []

  validation {
    condition = alltrue([
      for zone in var.opnsense_dhcp_zones :
      contains(["mgmt", "edge", "app", "data"], zone)
    ])
    error_message = "opnsense_dhcp_zones may contain only mgmt, edge, app, or data."
  }
}

variable "opnsense_nat_enabled" {
  type        = bool
  description = "Whether NAT is explicitly required on the OPNsense upstream path."
  default     = false
}
