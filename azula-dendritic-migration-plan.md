# Azula Dendritic Migration Plan

This document records the decisions we made for migrating the legacy config in `~/nixos-flakes` into the current working directory `~/myNixOS`.

The immediate focus is **a VM-first migration path for `azula` using `my-machine` as the proving host**.
We are deliberately not migrating `toph` yet, but we want the structure we create now to make `toph` easy to add next.

## Goal

Preserve the features currently available in `~/nixos-flakes/azula`, but reorganize the repo to follow the same style already used in `~/myNixOS`:

- thin `flake.nix`
- module discovery through `import-tree`
- flake composition through `flake-parts`
- host modules under `modules/hosts/`
- feature modules under `modules/features/`
- user modules under `modules/users/`

This is a structural migration first, not a rewrite for its own sake.

Active workspace:

- `~/myNixOS` is the new configuration repo we are building
- `~/nixos-flakes` is the legacy source we are migrating from

## Session Workflow

This session is being treated as a tutorial.

Working agreement:

- the user writes the code
- the assistant explains the next step explicitly
- the assistant maintains this plan file as the source of truth
- each step should be small enough to verify before moving on

Current execution rule:

1. explain the next change
2. make the smallest useful edit
3. verify that the result still evaluates or builds when practical
4. update this plan with what changed and what comes next

## Current Status

Current phase:

- Phase 1: Structural Migration On A VM Host First

Current step:

- Step 2. Get `my-machine` working as a minimal base host

Current next action:

- keep the existing thin `~/myNixOS/flake.nix`
- use `modules/hosts/my-machine/` as the first proving host
- keep growing `my-machine` toward a credible daily-work VM
- confirm the minimal base host is working with `ghostty`, `emacs`, and `zsh`
- move the desktop stack one step closer to the real workflow
- allow temporary manual user config where it speeds up testing
- begin extracting the parts of `my-machine` that already have a clear home
- continue extracting obvious shared features out of `my-machine`
- next extraction candidate: desktop/i3 tools
- prefer small feature modules over continuing to grow one host file
- defer Docker until after we have practiced one or two extractions cleanly
- keep expanding in small, teachable steps
- defer the `azula` host skeleton until the VM environment is close enough to real work
- defer legacy `azula` inputs until the base system shape is working

Current baseline artifact:

- `~/myNixOS/azula-current-behavior.md`

## Decisions Already Made

### 1. Target pattern

We will follow the pattern already present in `~/myNixOS`, not just a generic dendritic layout.

That means:

- a very small top-level `flake.nix`
- `flake-parts`
- `import-tree`
- exported flake modules from files under `modules/`

### 2. Scope

The current migration target is `azula`, but the structural migration should be proven in `~/myNixOS` on a dedicated VM host first.

We are intentionally deferring:

- `toph`
- any additional future machines
- broader cleanup that is not required for `azula`

That means the practical scope is:

- build the dendritic layout
- stand it up first on a VM host
- use that VM host to validate the shared structure
- then add `azula` on the same base with its real hardware, NVIDIA, filesystems, and host-specific details

### 3. User model

We want per-user configuration boundaries, not just account creation.

That means the long-term model should support:

- system account creation for each user
- per-user packages
- per-user shell/editor/git/session preferences
- per-user desktop configuration

Examples:

- `fedex` uses `i3`
- other users may not use `i3`
- a machine should import only the users it needs

### 4. Home Manager

Home Manager is recommended for this repo.

Reason:

- it gives each user a clean place for personal configuration
- it scales well when the same user exists on multiple machines
- it avoids overloading host files with user-specific session details

But we do **not** want to introduce it in the very first migration step if doing so makes debugging harder.

Recommended approach:

1. migrate `azula` into the dendritic structure first
2. keep the system bootable in the new structure
3. add Home Manager once the structural migration is stable

### 5. Naming convention

For now, reusable modules should use simple descriptive names.

Examples:

- `flake.nixosModules.fonts`
- `flake.nixosModules.cli`
- `flake.nixosModules.i3`

Do not add a personal prefix to reusable modules.

Use the `fdx` prefix only when we later create custom personal package outputs that need to be distinguished from upstream packages.

Examples of future custom output names:

- `packages.fdxEmacs`
- `packages.fdxGhostty`
- `packages.fdxNiri`

## Recommended Boundaries

Use these boundaries consistently.

### Hosts

`modules/hosts/<host>/...`

Host modules answer:

- what machine is this?
- what hardware does it have?
- what bootloader/disk/GPU/display specifics does it require?
- which users and features are enabled on this machine?

Examples of host-level concerns for `azula`:

- hardware scan import
- boot loader
- hostname
- NVIDIA-specific settings
- machine-specific X11 monitor layout
- filesystems
- host-specific service decisions

### Features

`modules/features/...`

Feature modules answer:

- what capability do we want available?
- can this capability be reused by another host later?

Examples likely to become features:

- `ruby`
- `npm`
- `printing`
- `pipewire`
- `fonts`
- `desktop/i3`
- `desktop/x11`
- `services/openssh`
- `services/ollama`
- `virtualisation/docker`

Not every extraction needs to happen on day one.
We should only extract what is clear and helpful during the migration.

### Users

`modules/users/<name>/...`

User modules answer:

- who is this user?
- what should exist for them on this machine?
- what personal configuration belongs to them?

Long-term examples:

- `modules/users/fedex/default.nix`
- `modules/users/chini/default.nix`
- `modules/users/sofi/default.nix`
- `modules/users/emma/default.nix`

Each host should import only the users it actually needs.

## Recommended End State For This Repo

This is the target shape we are moving toward.

```text
myNixOS/
├── flake.nix
├── flake.lock
└── modules/
    ├── parts.nix
    ├── hosts/
    │   ├── my-machine/
    │   │   ├── default.nix
    │   │   ├── configuration.nix
    │   │   └── hardware.nix
    │   └── azula/
    │       ├── default.nix
    │       ├── configuration.nix
    │       └── hardware.nix
    ├── users/
    │   ├── fedex/
    │   │   └── default.nix
    │   ├── chini/
    │   │   └── default.nix
    │   ├── sofi/
    │   │   └── default.nix
    │   └── emma/
    │       └── default.nix
    └── features/
        ├── fonts.nix
        ├── pipewire.nix
        ├── printing.nix
        ├── ruby.nix
        ├── npm.nix
        ├── desktop/
        │   ├── i3.nix
        │   └── x11.nix
        ├── services/
        │   ├── ollama.nix
        │   └── openssh.nix
        └── virtualisation/
            └── docker.nix
```

This is a target, not a requirement for the first pass.

## Migration Strategy

We will migrate into `~/myNixOS` through a VM-first path and then bring `azula` onto the same structure.

The main principle is:

> Keep the config understandable and buildable at every stage.

We should avoid doing a full extraction of every concern in one step.

VM-first principle:

- first prove the dendritic flake shape and shared workstation configuration on the VM
- then add `azula` by reusing the same shared configuration and layering in only the real host-specific pieces

## Step List

These are the steps we should follow across sessions.

### Phase 1: Structural Migration On A VM Host First

#### Step 1. Capture the current `azula` behavior

Before moving files around, confirm what `azula` currently contains.

Checklist:

- current flake inputs
- current special arguments
- hardware import path
- packages
- services
- desktop stack
- user account settings
- Docker/rootless settings
- NVIDIA settings
- any machine-specific quirks

Why:

- this is our baseline
- it reduces the chance of silently losing behavior during refactor

Status:

- completed
- baseline recorded in `~/myNixOS/azula-current-behavior.md`
- priorities added so we know what must be preserved first during the structural move

#### Step 2. Create a thin top-level `flake.nix`

Use the top-level flake structure in `~/myNixOS` as the root of the migration.

Expected result:

- `flake.nix` declares inputs
- `flake.nix` uses `flake-parts`
- `flake.nix` uses `import-tree ./modules`

Why:

- this is the foundation of the pattern we chose
- it makes later host and feature additions much easier

Status:

- already satisfied by the current `~/myNixOS/flake.nix`
- no change needed before the first base host iteration

#### Step 3. Create `modules/parts.nix`

Add the systems list, matching the style of `~/myNixOS` unless there is a concrete reason to differ.

Why:

- this keeps the flake composition consistent with the current working pattern

Status:

- already satisfied by the current `~/myNixOS/modules/parts.nix`
- revisit only if this migration needs additional systems later

#### Step 4. Create `modules/hosts/my-machine/`

Create the first dendritic host for the migration VM.

Expected files:

- `modules/hosts/my-machine/default.nix`
- `modules/hosts/my-machine/configuration.nix`
- `modules/hosts/my-machine/hardware.nix`

Why:

- this lets us validate the new flake layout without changing `azula`
- it gives us a safe host to debug flake structure, imports, and shared config boundaries

#### Step 5. Make the VM host build in the new structure

Keep the VM host simple.

Recommended contents:

- same overall flake pattern we want for `azula`
- same user model direction
- same reusable workstation features when safe
- VM-specific hardware and boot settings only
- no `azula`-specific NVIDIA, monitor layout, filesystems, or service assumptions unless intentionally shared

Why:

- we want to validate the structure first, not clone all of `azula` into the VM

Tutorial note for the current session:

- go slower than the full migration plan
- first prove a tiny usable base system on `my-machine`
- add `ghostty` and `emacs` before adding legacy `azula` flake inputs or custom package wiring
- defer Home Manager until after the first minimal host is working, unless we decide that early user-level config is necessary for learning clarity

Current progress on the tutorial path:

- `my-machine` successfully builds as the proving host
- `emacs` and `ghostty` were added through `environment.systemPackages`
- `programs.zsh.enable = true` was added successfully
- `users.users.fedex.shell = pkgs.zsh` was added successfully
- a small workstation CLI base was added: `curl`, `git`, `jq`, `ripgrep`, `tree`
- extra daily-driver CLI tools were added: `fd`, `bat`, `htop`
- `i3` was enabled and supporting packages were added for a more realistic desktop workflow
- temporary manual `i3` user config is acceptable while we validate the VM as a real workstation
- autologin into the `i3` session for user `fedex` is working on the VM
- the next tutorial priority is structure: move obvious concerns out of the host file
- `fonts` was successfully extracted into `modules/features/fonts.nix`
- rebuilding taught an important flake rule: new module files must be tracked by git to be visible to flake evaluation
- `cli` was successfully extracted into `modules/features/cli.nix`
- `my-machine` now imports `cli` instead of owning those base CLI packages directly
- old generations are intentionally being kept for now during active iteration
- this confirms the basic host-module path is working
- `azula` remains deferred until `my-machine` is useful enough for real work

### Phase 2: Bring `azula` Onto The Proven Structure

#### Step 6. Create `modules/hosts/azula/`

Move `azula` into the host module structure.

Expected files:

- `modules/hosts/azula/default.nix`
- `modules/hosts/azula/configuration.nix`
- `modules/hosts/azula/hardware.nix`

Why:

- this gives `azula` a clean host boundary
- it mirrors the pattern used in `~/myNixOS`

#### Step 7. Make `azula` build in the new structure before deeper extraction

Keep most of the current host config intact at first if needed.

Why:

- the first success criterion is not perfect modularity
- the first success criterion is a correct structural migration with preserved behavior

### Phase 3: Extract Clear Features From `azula`

Only after the VM host and `azula` are both stable in the new structure.

#### Step 8. Extract the obvious reusable modules

Good first candidates:

- `ruby`
- `npm`
- `printing`
- `pipewire`
- `fonts`

Possible later candidates:

- `desktop/x11`
- `desktop/i3`
- `services/ollama`
- `virtualisation/docker`
- `services/openssh`

Why:

- these are capabilities, not machine identity
- they are likely to be reused by `toph` or later hosts

#### Step 9. Leave truly machine-specific logic in the host

Examples that likely stay in `azula`:

- monitor layout
- exact NVIDIA tuning
- filesystem layout
- boot specifics

Why:

- those settings answer what is special about `azula`
- forcing them into generic feature modules too early would reduce clarity

### Phase 4: Introduce User Boundaries

#### Step 10. Create `modules/users/fedex/default.nix`

Start with `fedex`, because `azula` only needs that user right now.

Initial responsibilities:

- account creation
- groups
- shell
- any clearly user-owned settings that are not yet in Home Manager

Why:

- this creates the boundary we want before adding more users
- it prepares the repo for `chini`, `sofi`, and `emma`

#### Step 11. Have hosts import only the users they need

For now:

- the VM host imports `fedex` if needed
- `azula` imports `fedex`

Later examples:

- another host might import `fedex` and `sofi`
- another might import only `emma`

Why:

- it cleanly separates user identity from host identity

### Phase 5: Add Home Manager

Only after the dendritic structure is stable.

#### Step 12. Add the Home Manager input and wire it into the flake

Why:

- this gives us a proper home-level configuration boundary
- it keeps personal configuration out of host files

#### Step 13. Expand `modules/users/fedex/` to own personal configuration

Candidates to move there:

- shell configuration
- git configuration
- user packages
- i3 configuration
- rofi
- dunst
- terminal preferences

Why:

- `fedex` uses `i3`, while other users may not
- this is exactly the kind of divergence Home Manager handles well

#### Step 14. Add future users when needed

When `chini`, `sofi`, or `emma` are added, create their user modules and import them only on the machines that need them.

Why:

- it keeps the repo scalable across multiple machines and users

## Recommended Order Of Work For The Next Sessions

This is the practical sequence I recommend.

1. Build the new structure directly in `~/myNixOS`
2. Create a VM host in `modules/hosts/my-machine/`
3. Validate the dendritic structure on the VM host
4. Move `azula` into `modules/hosts/azula/`
5. Preserve current behavior and make sure evaluation still works
6. Extract only the clearest feature modules
7. Create `modules/users/fedex/default.nix`
8. Add Home Manager after the structural migration is stable
9. Move `fedex` personal desktop/session config into Home Manager
10. Add `toph` next, reusing what the VM host and `azula` proved out

## What We Are Explicitly Avoiding

We are not trying to:

- migrate every host at once
- extract every possible feature in the first pass
- introduce clever abstractions early
- mix machine migration and user-environment migration more than necessary

## Decision Summary

Current recommendation:

1. Focus only on `azula`
2. Prove the new structure on a VM host before changing `azula`
   using `my-machine` as the first host
3. Match the `~/myNixOS` flake pattern exactly where practical
4. Keep host, feature, and user boundaries separate
5. Prepare for multiple users now
6. Introduce Home Manager, but after the structural migration is stable
7. Use the VM host plus `azula` as the template for bringing in `toph` next
