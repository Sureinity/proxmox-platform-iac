packer {
  required_plugins {
    proxmox = {
      source  = "github.com/hashicorp/proxmox"
      version = ">= 1.1.0"
    }
  }
}

variable "proxmox_url" {
  type = string
}

variable "proxmox_username" {
  type = string
}

variable "proxmox_api_token" {
  type = string
}

variable "proxmox_insecure_skip_tls_verify" {
  type    = bool
  default = false
}

variable "proxmox_node" {
  type = string
}

variable "proxmox_pool" {
  type    = string
  default = "infra-templates"
}

variable "source_template_name" {
  type = string
}

variable "template_name_override" {
  type    = string
  default = ""
}

variable "template_profile" {
  type    = string
  default = "base"
}

variable "build_id" {
  type    = string
  default = ""
}

variable "debian_major_version" {
  type    = string
  default = "13"
}

variable "template_description_override" {
  type    = string
  default = ""
}

variable "bootstrap_bridge" {
  type    = string
  default = "vmbr0"
}

variable "cloud_init_storage_pool" {
  type = string
}

variable "ssh_username" {
  type    = string
  default = "debian"
}

variable "ssh_timeout" {
  type    = string
  default = "20m"
}

variable "cpu_cores" {
  type    = number
  default = 2
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "bootstrap_dns_servers" {
  type    = list(string)
  default = ["1.1.1.1", "8.8.8.8"]
}

variable "bootstrap_search_domain" {
  type    = string
  default = "localdomain"
}

variable "manifest_output" {
  type    = string
  default = "output/debian-13-base-manifest.json"
}

locals {
  effective_build_id   = var.build_id != "" ? var.build_id : regex_replace(timestamp(), "[- TZ:]", "")
  template_name        = var.template_name_override != "" ? var.template_name_override : "tmpl-debian-${var.debian_major_version}-${var.template_profile}-${local.effective_build_id}"
  build_vm_name        = "packer-debian-${var.debian_major_version}-${var.template_profile}-${local.effective_build_id}"
  template_description = var.template_description_override != "" ? var.template_description_override : "Debian ${var.debian_major_version} ${var.template_profile} template built ${timestamp()}"
  template_tags        = ["packer", "template", "debian", "debian-${var.debian_major_version}", var.template_profile]
}

source "proxmox-clone" "debian_base" {
  proxmox_url              = var.proxmox_url
  username                 = var.proxmox_username
  token                    = var.proxmox_api_token
  insecure_skip_tls_verify = var.proxmox_insecure_skip_tls_verify
  node                     = var.proxmox_node
  pool                     = var.proxmox_pool

  clone_vm   = var.source_template_name
  full_clone = true

  vm_name              = local.build_vm_name
  template_name        = local.template_name
  template_description = local.template_description
  tags                 = join(";", local.template_tags)

  os       = "l26"
  cores    = var.cpu_cores
  memory   = var.memory_mb
  cpu_type = var.cpu_type

  network_adapters {
    model    = "virtio"
    bridge   = var.bootstrap_bridge
    firewall = true
  }

  ipconfig {
    ip  = "dhcp"
    ip6 = "auto"
  }

  nameserver   = join(" ", var.bootstrap_dns_servers)
  searchdomain = var.bootstrap_search_domain

  cloud_init              = true
  cloud_init_storage_pool = var.cloud_init_storage_pool
  qemu_agent              = true

  ssh_username = var.ssh_username
  ssh_timeout  = var.ssh_timeout
}

build {
  name    = "debian-13-base"
  sources = ["source.proxmox-clone.debian_base"]

  provisioner "shell" {
    environment_vars = ["DEBIAN_FRONTEND=noninteractive"]
    scripts = [
      "scripts/baseline.sh",
      "scripts/cleanup.sh",
    ]
  }

  post-processor "manifest" {
    output     = var.manifest_output
    strip_path = true
    custom_data = {
      build_id             = local.effective_build_id
      bootstrap_username   = var.ssh_username
      bootstrap_bridge     = var.bootstrap_bridge
      cloud_init_pool      = var.cloud_init_storage_pool
      debian_major_version = var.debian_major_version
      template_node_name   = var.proxmox_node
      source_template_name = var.source_template_name
      template_name        = local.template_name
      template_profile     = var.template_profile
    }
  }
}
