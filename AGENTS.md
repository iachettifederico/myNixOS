# AGENTS.md

## Repo Purpose

- This repo is the new NixOS configuration being built in `~/myNixOS`.
- `~/nixos-flakes` is the legacy source being migrated from; do not treat it as the active config tree.
- Current migration strategy is VM-first: `my-machine` is the proving host, `toph` is already using the dendritic structure, and `azula` stays deferred until the VM is close to a real daily-work environment.

## Source Of Truth

- Read `docs/azula-dendritic-migration-plan.md` before making structural changes. It is the maintained migration plan for this repo.
- Read `docs/azula-current-behavior.md` when porting behavior from the legacy `azula` config.

## Flake Structure

- The root flake is intentionally thin: `flake.nix` delegates to `flake-parts` and `import-tree ./modules`.
- Reusable NixOS modules are exported as `flake.nixosModules.<name>` from files under `modules/`.
- Host registration lives in `modules/hosts/<host>/default.nix` via `flake.nixosConfigurations.<HostName>`.
- `modules/parts.nix` defines supported systems; do not add host logic there.

## Current Architecture

- Active hosts:
  - `modules/hosts/my-machine/`
  - `modules/hosts/toph/`
- Extracted reusable features currently include:
  - `modules/features/fonts.nix`
  - `modules/features/cli.nix`
  - `modules/features/desktop/i3.nix`
  - `modules/features/ai/opencode.nix`
- `modules/features/niri.nix` is a different pattern: it exports a wrapped package via `perSystem`, not a reusable NixOS module.

## Naming Conventions

- Reusable modules keep simple names: `fonts`, `cli`, `i3`.
- Reserve the `fdx` prefix for future custom personal package outputs only, for example `packages.fdxEmacs`.
- Do not add personal prefixes to `flake.nixosModules.*` names.

## Build And Verification

- Primary rebuild command for the VM host: `sudo nixos-rebuild switch --flake .#myMachine`
- Current laptop rebuild command: `sudo nixos-rebuild switch --flake .#toph`
- Useful quick check for exported modules: `nix eval .#nixosModules --apply builtins.attrNames`

## Critical Flake Gotcha

- New files must be tracked by Git before flake evaluation can see them.
- If you add a new module file and forget to `git add` it, rebuilds can fail with missing flake attributes even though the file exists on disk.

## Workflow Expectations

- Prefer small extractions from host files into feature modules instead of continuing to grow a single host configuration.
- Keep `my-machine` usable while migrating; favor small, reversible steps.
- `toph` is no longer deferred; keep its host-specific graphics configuration in `modules/hosts/toph/configuration.nix` unless the same pattern is proven elsewhere.
- Delay Docker, Home Manager, and `azula` host bring-up until the shared VM structure is stable enough to do real work in it.
