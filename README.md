# myNixOS

This repo is the new NixOS configuration being built in `~/myNixOS`.

It is replacing the older configuration in `~/nixos-flakes` through a VM-first migration:

- `my-machine` is the proving host
- `toph` has already been brought into the dendritic structure
- `azula` is being migrated later, after the VM is close enough to a real daily-work environment

## Current Status

- The root flake already uses the dendritic pattern:
  - `flake-parts`
  - `import-tree ./modules`
  - reusable `flake.nixosModules.*`
- `my-machine` is the current VM proving host under `modules/hosts/my-machine/`
- `toph` is also present as a real dendritic host under `modules/hosts/toph/`
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
├── docs/
└── *.md
```

Important locations:

- `modules/parts.nix`: supported systems for `flake-parts`
- `modules/hosts/my-machine/`: current VM proving host
- `modules/hosts/toph/`: laptop host already using the dendritic structure
- `modules/features/`: reusable feature modules extracted from host config
- `docs/azula-dendritic-migration-plan.md`: active migration plan
- `docs/azula-current-behavior.md`: captured baseline from the legacy `azula` config
- `docs/toph-graphics-progress.md`: host-specific notes for the current `toph` graphics bring-up

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
- Keep module names simple, such as `fonts`, `cli`, `i3`, and `opencode`.
- Reserve the `fdx` prefix for future custom personal package outputs.
- New files must be tracked by Git before flake evaluation can see them.

## Related Docs

- `AGENTS.md`: compact repo-specific working guidance
- `docs/azula-dendritic-migration-plan.md`: current migration strategy and checkpoints
- `docs/azula-current-behavior.md`: verified baseline for porting legacy `azula` behavior
