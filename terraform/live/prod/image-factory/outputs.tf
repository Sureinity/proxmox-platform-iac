output "template_contract" {
  description = "Approved template identity contract consumed by downstream Terraform."
  value       = local.template_contract
}

output "template_vm_id" {
  description = "Proxmox VM ID of the approved template artifact."
  value       = local.template_contract.template_vm_id
}

output "template_name" {
  description = "Approved template name."
  value       = local.template_contract.template_name
}

output "template_node_name" {
  description = "Node where the approved template exists."
  value       = local.template_contract.template_node_name
}

output "bootstrap_username" {
  description = "Bootstrap SSH username baked into the approved template."
  value       = local.template_contract.bootstrap_username
}
