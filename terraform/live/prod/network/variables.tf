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

variable "zone_id" {
  type        = string
  description = "Production SDN zone identifier."
}

variable "vnet_id" {
  type        = string
  description = "Production VNet identifier."
}

variable "node_names" {
  type        = list(string)
  description = "Proxmox nodes where the production SDN zone is available."
}

variable "subnet_cidr" {
  type        = string
  description = "Production SDN subnet CIDR."
}

variable "gateway" {
  type        = string
  description = "Production SDN subnet gateway IP."
}

variable "dhcp_range" {
  type = object({
    start_address = string
    end_address   = string
  })
  description = "Production SDN DHCP address range."
}

variable "enable_snat" {
  type        = bool
  description = "Whether SNAT is enabled on the production SDN subnet."
  default     = true
}
