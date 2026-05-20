output "vms" {
  description = "Created workload VMs keyed by inventory name."
  value = {
    for key, vm in module.vm : key => {
      name               = vm.name
      vm_id              = vm.vm_id
      node_name          = vm.node_name
      zone               = local.normalized_vms[key].zone
      bridge             = local.normalized_vms[key].bridge
      ipv4_address       = vm.ipv4_address
      ipv4_gateway       = local.normalized_vms[key].ipv4_gateway
      bootstrap_username = vm.bootstrap_username
      ansible_group      = local.normalized_vms[key].ansible_group
    }
  }
}

output "ansible_inventory" {
  description = "Version 1 Terraform-to-Ansible inventory contract."
  value = {
    all = {
      children = {
        linux = {
          children = {
            for group in toset([
              for key, vm in module.vm : local.normalized_vms[key].ansible_group
              if vm.ipv4_address != "dhcp"
              ]) : group => {
              hosts = {
                for key, vm in module.vm : key => {
                  ansible_host = split("/", vm.ipv4_address)[0]
                  ansible_user = vm.bootstrap_username
                }
                if vm.ipv4_address != "dhcp" && local.normalized_vms[key].ansible_group == group
              }
            }
          }
        }
      }
    }
  }
}
