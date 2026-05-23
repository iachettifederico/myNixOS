# Toph Graphics Progress

This file records the recent work to get `toph` into a usable graphical state after the NVIDIA configuration broke the desktop.

## Context

- Machine: Lenovo LOQ 15IAX9
- Host: `toph`
- Config repo: `~/myNixOS`
- Legacy reference: `~/nixos-flakes/toph/`
- Current framework: thin root flake, `flake-parts`, `import-tree`, dendritic modules under `modules/hosts/` and `modules/features/`

## What Was Investigated

- Read the legacy host config in `~/nixos-flakes/toph/configuration.nix`
- Compared it with the dendritic host in `modules/hosts/toph/`
- Checked the running machine state and boot logs
- Confirmed the hardware is a hybrid Intel + NVIDIA laptop

Important findings:

- The internal panel is currently working through the Intel path
- The laptop exposes Optimus/PRIME-style hybrid graphics
- The legacy NVIDIA block enabled `videoDrivers = [ "nvidia" ]` and `hardware.nvidia`, but did not configure `hardware.nvidia.prime.*`
- That shape is a poor fit for this laptop and was the most likely cause of the broken graphical session

## Decision

For `toph`, the best first usable configuration is:

- Intel drives the desktop
- NVIDIA is available for offload and compute on demand
- External monitor support is deferred until the internal-panel setup is stable

This keeps the configuration aligned with the dendritic design by placing host-specific GPU wiring in `modules/hosts/toph/configuration.nix` rather than forcing it into a shared feature too early.

## Change Made

Updated:

- `modules/hosts/toph/configuration.nix`

Added a host-specific NVIDIA PRIME offload configuration:

```nix
services.xserver.videoDrivers = [ "nvidia" ];

hardware.nvidia = {
  # Hybrid laptop: keep the desktop on Intel and use NVIDIA on demand.
  open = false;
  modesetting.enable = true;
  powerManagement.enable = false;
  nvidiaSettings = true;

  prime = {
    offload.enable = true;
    offload.enableOffloadCmd = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
};
```

## Why This Configuration

- It matches the actual `toph` hardware: Intel iGPU plus NVIDIA dGPU
- It is the least risky path to restoring a usable desktop
- It keeps power usage and complexity lower than forcing the full desktop onto NVIDIA
- It leaves room to move to PRIME sync later if external monitor routing requires it

## Verification Performed

Evaluated successfully:

```bash
nix eval .#nixosConfigurations.toph.config.services.xserver.videoDrivers
nix eval .#nixosConfigurations.toph.config.hardware.nvidia.prime.offload.enable
```

Full system build completed successfully:

```bash
nix build .#nixosConfigurations.toph.config.system.build.toplevel
```

## Apply The Configuration

From `~/myNixOS`:

```bash
sudo nixos-rebuild switch --flake .#toph
```

## Expected Behavior After Switch

- Internal laptop panel should continue to use the Intel-driven desktop path
- NVIDIA should be available through offload commands
- `lightdm` + `i3` remains the intended desktop stack for `toph`

## Current Outcome

- The dendritic `toph` rebuild applied successfully
- A reboot was required after switching generations
- After reboot, the graphical interface did not break
- The internal panel remained usable with the new host-specific PRIME offload configuration

Useful follow-up test:

```bash
nvidia-offload glxinfo | rg "OpenGL renderer"
```

## Known Next Step

If external monitors are needed and do not behave correctly with PRIME offload, the next thing to test is a host-specific PRIME sync configuration for `toph`.

That should still remain host-specific unless the same pattern is proven on another machine.
