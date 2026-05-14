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
  description = "Allow insecure TLS connections to Proxmox. Use only for labs with self-signed certificates."
  default     = false
}

variable "template_vm_id" {
  type        = number
  description = "Source VM template ID from image-factory outputs."
}

variable "default_node_name" {
  type        = string
  description = "Default Proxmox node for workload VMs."
}

variable "default_bridge" {
  type        = string
  description = "Default Proxmox bridge or VNet for workload VMs."
}

variable "cloud_init_datastore_id" {
  type        = string
  description = "Datastore used for workload cloud-init media."
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

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers configured by cloud-init."
  default     = ["1.1.1.1", "8.8.8.8"]
}

variable "vms" {
  type = map(object({
    name          = string
    vm_id         = number
    ipv4_address  = string
    ipv4_gateway  = optional(string)
    node_name     = optional(string)
    bridge        = optional(string)
    cpu_cores     = optional(number, 2)
    memory_mb     = optional(number, 2048)
    started       = optional(bool, true)
    on_boot       = optional(bool, true)
    ansible_group = optional(string, "debian_trixie")
  }))
  description = "Workload VM definitions keyed by stable inventory name."

  validation {
    condition     = length(var.vms) > 0 && alltrue([for _, vm in var.vms : vm.vm_id >= 100 && vm.vm_id <= 999999999])
    error_message = "Each VM must have a vm_id between 100 and 999999999."
  }

  validation {
    condition     = alltrue([for _, vm in var.vms : vm.ipv4_address == "dhcp" || can(cidrhost(vm.ipv4_address, 0))])
    error_message = "Each VM ipv4_address must be dhcp or a valid CIDR address."
  }
}
