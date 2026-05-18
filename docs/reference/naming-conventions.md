# Naming Conventions

## General Rules

- Use lowercase ASCII names.
- Prefer hyphen-separated names for resources and modules that become path or VM identifiers.
- Prefer snake_case for Terraform variables, outputs, and Ansible inventory groups.
- Keep names stable and descriptive. Do not encode transient implementation details into public contracts.

## VM Names

VM names must follow:

```text
prod-<role>-<index>
```

Examples:

- `prod-traefik-01`
- `prod-app-01`
- `prod-postgres-01`

Rules:

- `prod` is required because `prod` is the only real environment
- `<role>` describes the workload function
- `<index>` is a zero-padded ordinal for future horizontal scaling

## Template Names

Template names must follow:

```text
tmpl-<os>-<major>-<profile>-<build_id>
```

Examples:

- `tmpl-debian-13-base-20260518`
- `tmpl-debian-13-app-20260518`

Rules:

- start with `tmpl-`
- include the operating system and major version
- include a profile or purpose marker
- include a build identifier that changes when the image is rebuilt

## Zone Names

Zone names are fixed project terms:

- `mgmt`
- `edge`
- `app`
- `data`

Do not introduce alternate spellings such as `management`, `dmz`, or `database` in resource identifiers where the zone name itself is the contract.

## Terraform Module Names

Terraform module directories must be capability-based and lowercase hyphen-separated.

Examples:

- `proxmox-sdn`
- `proxmox-cloud-image`
- `proxmox-template`
- `proxmox-vm`

Rules:

- name the capability, not the environment
- avoid stack names such as `prod-network-module`
- prefix with `proxmox-` when the module is Proxmox-specific

## Terraform Variable Names

Terraform variables must use `snake_case`.

Rules:

- use singular nouns for single values: `template_vm_id`
- use plural nouns for collections: `dns_servers`
- use boolean prefixes such as `enable_`, `use_`, or `create_`
- keep module variables environment-agnostic

## Terraform Output Names

Terraform outputs must use `snake_case` and be consumer-oriented.

Examples:

- `template_vm_id`
- `zone_id`
- `ansible_inventory`

Rules:

- expose stable handoff contracts
- avoid leaking internal resource addresses or temporary names
- choose names that remain valid if implementation details change

## Inventory Groups

Inventory groups must use `snake_case` and represent operational roles, not ad hoc host labels.

Preferred Version 1 groups:

- `edge_proxies`
- `app_nodes`
- `postgresql_nodes`

Optional shared groups may be added when they express a real control boundary, such as `linux` or `container_hosts`.

Do not encode the environment name into inventory groups because the repository has only one real environment.
