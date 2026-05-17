# myNixOS

This repo is the new NixOS configuration being built in `~/myNixOS`.

It is replacing the older configuration in `~/nixos-flakes` through a VM-first migration:

- `my-machine` is the proving host
- `azula` is being migrated later, after the VM is close enough to a real daily-work environment

## Current Status

- The root flake already uses the dendritic pattern:
  - `flake-parts`
  - `import-tree ./modules`
  - reusable `flake.nixosModules.*`
- `my-machine` is the active host under `modules/hosts/my-machine/`
- Some shared features have already been extracted into `modules/features/`

## Repository Layout

```text
.
├── flake.nix
├── flake.lock
├── modules/
│   ├── parts.nix
│   ├── features/
│   └── hosts/
└── *.md
```

Important locations:

- `modules/parts.nix`: supported systems for `flake-parts`
- `modules/hosts/my-machine/`: current VM host
- `modules/features/`: reusable feature modules extracted from host config
- `azula-dendritic-migration-plan.md`: active migration plan
- `azula-current-behavior.md`: captured baseline from the legacy `azula` config

## Build

Primary rebuild command for the VM host:

```bash
sudo nixos-rebuild switch --flake .#myMachine
```

Useful flake/module check:

```bash
nix eval .#nixosModules --apply builtins.attrNames
```

## Workflow Notes

- Prefer extracting clear reusable features instead of continuing to grow one host file.
- Keep module names simple, such as `fonts`, `cli`, and `i3`.
- Reserve the `fdx` prefix for future custom personal package outputs.
- New files must be tracked by Git before flake evaluation can see them.

## Related Docs

- `AGENTS.md`: compact repo-specific working guidance
- `azula-dendritic-migration-plan.md`: current migration strategy and checkpoints
- `azula-current-behavior.md`: verified baseline for porting legacy `azula` behavior
