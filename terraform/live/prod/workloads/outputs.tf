output "vms" {
  description = "Created workload VMs keyed by inventory name."
  value = {
    for key, vm in module.vm : key => {
      name               = vm.name
      vm_id              = vm.vm_id
      node_name          = vm.node_name
      ipv4_address       = vm.ipv4_address
      bootstrap_username = vm.bootstrap_username
      ansible_group      = var.vms[key].ansible_group
    }
  }
}

output "ansible_inventory_hosts" {
  description = "Ansible-ready host map derived from workload VM definitions."
  value = {
    for key, vm in module.vm : key => {
      ansible_host = split("/", vm.ipv4_address)[0]
      ansible_user = vm.bootstrap_username
      groups       = [var.vms[key].ansible_group]
    }
    if vm.ipv4_address != "dhcp"
  }
}
