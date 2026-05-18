# Implementation Phases

This roadmap translates the accepted architecture into sequential delivery milestones. Each phase is intended to be implemented as a real work package with clear ownership and exit criteria.

## Phase 1: Repository Foundation and Documentation Baseline

**Goal**

Establish the project contracts, terminology, documentation model, and repository ownership boundaries before expanding implementation.

**Scope**

- Diataxis documentation structure
- architecture, scope, and naming contracts
- ADR baseline
- roadmap and milestone documents
- root README pointers into the new documentation surface

**Key outputs and artifacts**

- `docs/` Diataxis structure
- ADR set
- roadmap documents
- updated root documentation pointers

**Dependencies**

- none

**Exit criteria**

- the accepted architecture decisions are documented as stable contracts
- the repository has one authoritative documentation surface under `docs/`
- implementation phases and milestone boundaries are reviewable without reading code

**Risks**

- legacy documentation may continue to contradict the new contract
- implementation may drift if contributors skip the documentation baseline

## Phase 2: Packer Image Factory

**Goal**

Introduce an immutable image pipeline that produces the base guest image inputs for Proxmox templates.

**Scope**

- `packer/` repository area
- base image build definition
- template naming and artifact versioning
- image build inputs aligned with the Ansible baseline target

**Key outputs and artifacts**

- `packer/` directory structure
- image build configuration
- image versioning metadata or manifest contract
- documentation updates where implementation details become concrete

**Dependencies**

- Phase 1

**Exit criteria**

- Packer can produce a reusable image artifact for the platform template flow
- image naming follows the accepted naming convention
- no runtime service configuration is embedded in the image build beyond base-image concerns

**Risks**

- image build logic can absorb runtime concerns that belong in Ansible
- inconsistent image versioning can destabilize downstream template and workload changes

## Phase 3: Terraform Network Layer

**Goal**

Implement the four-zone network contract in the `network` state.

**Scope**

- `terraform/live/prod/network`
- capability modules required for zone and subnet provisioning
- `mgmt`, `edge`, `app`, and `data` addressing and routing contracts
- network outputs required by downstream workload placement

**Key outputs and artifacts**

- network root module implementation
- network capability module implementation
- reviewed outputs for downstream consumers
- documentation updates if enforcement details become concrete

**Dependencies**

- Phase 1

**Exit criteria**

- the four accepted subnets exist in the network layer
- the zone contract matches the documented traffic model
- no workload-specific configuration is embedded in the network state

**Risks**

- network implementation may diverge from the documented trust model
- shared-network changes carry platform-wide blast radius

## Phase 4: Terraform Image-Factory Layer Integration

**Goal**

Connect the Packer image pipeline to the Proxmox template lifecycle through the `image-factory` state.

**Scope**

- `terraform/live/prod/image-factory`
- cloud image or artifact import into Proxmox
- template creation from the approved image build
- template outputs consumed by the workload layer

**Key outputs and artifacts**

- image-factory root module implementation
- reusable template creation flow
- stable template identity outputs

**Dependencies**

- Phase 2
- Phase 3 for any network attachment assumptions used by template creation

**Exit criteria**

- Terraform can create a reusable Proxmox template from the image-factory artifact
- template naming and outputs follow the documented contracts
- cloud-init input remains bootstrap-only

**Risks**

- image and template version drift can make workload rollouts unpredictable
- template bootstrapping can expand beyond the accepted cloud-init scope

## Phase 5: Terraform Workloads Layer

**Goal**

Provision the Version 1 workload VMs and publish the Terraform-to-Ansible handoff contract.

**Scope**

- `terraform/live/prod/workloads`
- Traefik proxy VM
- application VM
- PostgreSQL VM
- stable inventory output contract for Ansible

**Key outputs and artifacts**

- workload root module implementation
- VM definitions for the three Version 1 workloads
- stable `ansible_inventory` Terraform output

**Dependencies**

- Phase 3
- Phase 4

**Exit criteria**

- the three Version 1 VMs can be provisioned from the approved template flow
- host identity, SSH user, SSH keys, and networking are provided through cloud-init only
- Terraform does not run Ansible or embed guest configuration logic
- the `ansible_inventory` output is stable enough for downstream consumption

**Risks**

- workload code can leak service configuration into Terraform
- unstable output names can break the Ansible handoff
- incorrect network placement can violate the trust model

## Phase 6: Ansible Baseline Configuration

**Goal**

Implement guest configuration that begins after infrastructure provisioning and respects the handoff boundary.

**Scope**

- `ansible/inventories/prod/`
- baseline roles and playbooks
- package baseline
- user management
- SSH hardening
- Docker or runtime setup
- service configuration for the Version 1 workloads as implementation expands

**Key outputs and artifacts**

- inventory examples
- baseline role
- service-specific roles or playbooks where required
- guest-configuration documentation updates if needed

**Dependencies**

- Phase 5

**Exit criteria**

- Ansible can target the Terraform-derived inventory contract
- baseline configuration is idempotent
- SSH hardening and automation-user creation follow the documented ownership split
- service configuration is separated from infrastructure provisioning

**Risks**

- baseline roles can accumulate workload-specific logic and become hard to maintain
- guest configuration may rely on undocumented Terraform assumptions

## Phase 7: CI Validation Layer

**Goal**

Add validation-only automation that continuously checks repository quality without applying infrastructure.

**Scope**

- GitHub Actions for Terraform validation
- GitHub Actions for Ansible syntax and lint checks
- static configuration security checks

**Key outputs and artifacts**

- `.github/workflows/terraform.yml`
- `.github/workflows/ansible.yml`
- `.github/workflows/security.yml`
- documentation of CI behavior and assumptions

**Dependencies**

- Phases 3 through 6, because CI should validate real repository surfaces

**Exit criteria**

- pull requests can run validation without live Proxmox credentials
- CI covers formatting, validation, syntax, and selected static security checks
- no CI job performs live apply or mutable deployment actions in Version 1

**Risks**

- CI may drift from local developer workflows
- validation gaps may hide contract regressions until later phases

## Phase 8: Inventory and Output Handoff Hardening

**Goal**

Stabilize the Terraform-to-Ansible inventory handoff so it is repeatable, documented, and hard to misuse.

**Scope**

- finalize the `ansible_inventory` output contract
- define or implement the local generation command
- align Terraform host naming with Ansible groups
- remove hand-edited inventory dependencies where possible

**Key outputs and artifacts**

- final Terraform inventory output contract
- documented or automated inventory generation flow
- updated inventory examples and handoff docs

**Dependencies**

- Phase 5
- Phase 6
- Phase 7

**Exit criteria**

- a documented generation path exists from Terraform output to `ansible/inventories/prod/hosts.yml`
- the inventory contract is stable and matches the naming conventions
- downstream playbooks can assume a consistent group structure

**Risks**

- mismatched host and group names can create fragile playbooks
- output-shape changes can break automation unless contract changes are explicitly reviewed
