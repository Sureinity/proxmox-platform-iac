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

variable "template_contract" {
  type = object({
    template_vm_id     = number
    template_name      = string
    template_node_name = string
    bootstrap_username = string
    cloud_init_storage = string
  })
  description = "Approved template contract consumed from the image-factory root outputs."
}

variable "default_node_name" {
  type        = string
  description = "Optional override for the default Proxmox node used by workload VMs."
  default     = null
}

variable "zone_bridges" {
  type = object({
    mgmt = string
    edge = string
    app  = string
    data = string
  })
  description = "Zone-to-bridge mapping consumed from the network root outputs."
}

variable "zone_gateways" {
  type = object({
    mgmt = string
    edge = string
    app  = string
    data = string
  })
  description = "Zone gateway CIDR addresses owned by OPNsense."

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

variable "cloud_init_datastore_id_override" {
  type        = string
  description = "Optional override for the cloud-init datastore used by workload VMs."
  default     = null
}

variable "bootstrap_ssh_public_keys" {
  type        = list(string)
  description = "SSH public keys authorized for bootstrap access."
  sensitive   = true
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers configured by cloud-init."
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "vms" {
  type = map(object({
    name          = string
    zone          = string
    vm_id         = number
    ipv4_address  = string
    ipv4_gateway  = optional(string)
    node_name     = optional(string)
    bridge        = optional(string)
    cpu_cores     = optional(number, 2)
    memory_mb     = optional(number, 2048)
    started       = optional(bool, true)
    on_boot       = optional(bool, true)
    ansible_group = optional(string)
  }))
  description = "Workload VM definitions keyed by stable inventory name."

  validation {
    condition     = length(var.vms) > 0 && alltrue([for _, vm in var.vms : vm.vm_id >= 100 && vm.vm_id <= 999999999])
    error_message = "Each VM must have a vm_id between 100 and 999999999."
  }

  validation {
    condition     = alltrue([for _, vm in var.vms : contains(["mgmt", "edge", "app", "data"], vm.zone)])
    error_message = "Each VM zone must be one of mgmt, edge, app, or data."
  }

  validation {
    condition     = alltrue([for _, vm in var.vms : vm.ipv4_address == "dhcp" || can(cidrhost(vm.ipv4_address, 0))])
    error_message = "Each VM ipv4_address must be dhcp or a valid CIDR address."
  }
}
