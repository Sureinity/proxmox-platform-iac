variable "node_name" {
  type        = string
  description = "Proxmox node that downloads and stores the cloud image."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.node_name))
    error_message = "node_name must be a valid Proxmox node name."
  }
}

variable "datastore_id" {
  type        = string
  description = "Proxmox datastore used for imported cloud images."

  validation {
    condition     = can(regex("^[A-Za-z0-9._-]+$", var.datastore_id))
    error_message = "datastore_id must be a valid Proxmox datastore identifier."
  }
}

variable "image_url" {
  type        = string
  description = "HTTPS URL for the cloud image."

  validation {
    condition     = can(regex("^https://.+\\.(qcow2|img|raw)(\\?.*)?$", var.image_url))
    error_message = "image_url must be an HTTPS URL ending with qcow2, img, or raw."
  }
}
