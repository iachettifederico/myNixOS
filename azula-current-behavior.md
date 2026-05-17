# Azula Current Behavior Baseline

This document captures the current behavior of `~/nixos-flakes/azula` before the dendritic migration.

Purpose:

- preserve behavior during structural refactors
- decide what belongs to host modules, feature modules, and future user modules
- give us a checklist for validating the migration

Priority legend:

- `P0`: must survive the migration exactly for the machine to stay usable or bootable
- `P1`: important system behavior that should be preserved in the first structural pass
- `P2`: useful behavior that can be preserved a little later if needed, but should still be tracked

## Flake Inputs

Priority: `P0`

Source: `~/nixos-flakes/azula/flake.nix`

Current behavior:

- `nixpkgs` tracks `github:nixos/nixpkgs?ref=nixos-unstable`
- `nixpkgs-master` tracks `github:nixos/nixpkgs/master`
- `nixpkgs-ruby` tracks `github:bobvanderlinden/nixpkgs-ruby` and follows `nixpkgs`
- `emacs-overlay` tracks `github:nix-community/emacs-overlay` and follows `nixpkgs`

Migration notes:

- all four inputs must be accounted for in the new top-level flake
- `nixpkgs-master` is used for `pkgs-master.opencode`
- `nixpkgs-ruby` is used both for system modules and exported packages/devShells
- `emacs-overlay` is used to build the custom Emacs package

Likely future home:

- top-level `flake.nix`

## Package Set And Overlays

Priority: `P0`

Source: `~/nixos-flakes/azula/flake.nix`

Current behavior:

- system is hardcoded as `x86_64-linux`
- `pkgs-master` is imported from `nixpkgs-master`
- `pkgs` is imported from `nixpkgs` with overlays
- overlays include:
  - `emacs-overlay.overlays.default`
  - a `folly` override that sets `doCheck = false`
  - a `tree-sitter-grammars` override that sets `tree-sitter-quint = null`

Migration notes:

- these overlays are behavior, not just implementation detail
- dropping them may break Emacs or packages that currently build successfully

Likely future home:

- top-level flake wiring or a small shared flake helper if needed later

## Custom Emacs Build

Priority: `P1`

Source: `~/nixos-flakes/azula/flake.nix`

Current behavior:

- builds `treesit-grammars-filtered` by removing null grammars and `tree-sitter-quint`
- builds `emacs-with-grammars` using `pkgs.emacsWithPackagesFromUsePackage`
- package is based on `pkgs.emacs-gtk`
- extra Emacs packages include:
  - `treesit-grammars-filtered`
  - `use-package`
  - `envrc`
  - `yaml-mode`
  - `nix-mode`
  - `dockerfile-mode`

Migration notes:

- this is currently flake-level package wiring, not a host module option
- it is consumed through `specialArgs` and installed in `environment.systemPackages`

Likely future home:

- flake-level package wiring, then passed into the host module

## specialArgs

Priority: `P0`

Source: `~/nixos-flakes/azula/flake.nix`

Current behavior:

- `ruby-packages = nixpkgs-ruby.packages.${system}`
- `pkgs-master`
- `emacs-with-grammars`

Migration notes:

- these must continue to be passed into the NixOS configuration in the new `nixosSystem`
- `ruby-packages` is required by `./modules/ruby.nix`

Likely future home:

- `modules/hosts/azula/default.nix`

## Current NixOS Module List

Priority: `P0`

Source: `~/nixos-flakes/azula/flake.nix`

Current behavior:

- `./configuration.nix`
- `./modules/ruby.nix`
- `./modules/npm.nix`

Migration notes:

- the first structural pass should keep these modules active
- `ruby.nix` and `npm.nix` are good feature-extraction candidates later, but do not need to move in the first pass

Likely future home:

- `modules/hosts/azula/default.nix` imports `self.nixosModules.azulaConfiguration`
- `modules/hosts/azula/configuration.nix` imports host hardware and whichever modules we keep enabled initially

## Hardware Import And Disk Layout

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`, `~/nixos-flakes/azula/hardware-configuration.nix`

Current behavior:

- `configuration.nix` imports `./hardware-configuration.nix`
- hardware module imports `(modulesPath + "/installer/scan/not-detected.nix")`
- boot initrd kernel modules:
  - `nvme`
  - `xhci_pci`
  - `ahci`
  - `usbhid`
  - `usb_storage`
  - `sd_mod`
- initrd kernel modules include `dm-snapshot`
- kernel modules include `kvm-amd`
- filesystems:
  - `/` on UUID `f85ca9d5-d6b8-4c4b-a6f8-6b715f49d48f`
  - `/boot` on UUID `DA2C-A523`
  - `/home` on UUID `6a09a080-da5c-469e-a796-8acdf6c61bac`
  - `/home/fedex/Data` on `/dev/vg-data/data`
  - `/home/fedex/Media` on `/dev/vg-data/media`
  - `/home/fedex/Books` on `/dev/vg-data/books`
  - `/home/fedex/Isos` on `/dev/vg-data/isos`
  - `/home/fedex/.local/share/Steam` on `/dev/vg-main/gaming`
  - `/home/fedex/VMs` on `/dev/vg-data/virtual-box-vms`
  - `/var/lib/ollama` on `/dev/vg-data/ai-models`
- several non-root mounts use `options = [ "nofail" ]`
- `networking.useDHCP = lib.mkDefault true`
- `nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux"`
- `hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware`

Migration notes:

- this should move almost verbatim into `modules/hosts/azula/hardware.nix`
- filesystem and storage layout are strongly host-specific

Likely future home:

- `modules/hosts/azula/hardware.nix`

## Boot

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `boot.loader.systemd-boot.enable = true`
- `boot.loader.efi.canTouchEfiVariables = true`
- IPv4 forwarding enabled
- IPv6 forwarding enabled

Migration notes:

- bootloader settings remain host-specific
- IP forwarding matters for container and VM networking behavior

Likely future home:

- `modules/hosts/azula/configuration.nix`

## Networking

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- hostname is `azula`
- NetworkManager is enabled
- OpenSSH is enabled
- firewall allows TCP `80` and `443` globally
- firewall allows TCP `11434` only on interface `virbr0`

Migration notes:

- hostname is host-specific
- bridge-specific firewall rule is important because it allows VMs to reach Ollama without exposing it externally

Likely future home:

- hostname and bridge firewall rule stay in host config
- generic SSH enablement may later move to a feature module

## Nix Settings

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `nix.settings.experimental-features = [ "nix-command" "flakes" ]`
- `nixpkgs.config.allowUnfree = true`
- `nixpkgs.config.allowUnfreePredicate` also explicitly allows `1password-gui` and `1password`

Migration notes:

- allowing all unfree packages already covers the 1Password packages, but the explicit predicate is still part of current behavior and should be preserved for now rather than normalized during the structural migration

Likely future home:

- `modules/hosts/azula/configuration.nix`

## Locale, Timezone, And Console

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- timezone is `America/Argentina/Cordoba`
- default locale is `en_US.UTF-8`
- extra locale settings use `es_AR.UTF-8`
- console keymap is `us-acentos`
- XKB layout is `us`
- XKB variant is `intl`

Likely future home:

- `modules/hosts/azula/configuration.nix`

## Desktop Stack

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- X11 is enabled through `services.xserver.enable = true`
- LightDM is enabled
- i3 window manager is enabled
- display manager session commands run `${pkgs.xrandr}/bin/xrandr --output DP-4 --primary`
- `services.displayManager.autoLogin.enable = true`
- `services.displayManager.autoLogin.user = "fedex"`

Migration notes:

- the desktop stack is partially reusable, but the exact monitor selection and autologin user are machine- and user-sensitive
- first pass should keep this behavior together in the host config

Likely future home:

- first pass: `modules/hosts/azula/configuration.nix`
- later: generic X11/i3 pieces may move to `modules/features/desktop/...`

## NVIDIA And Graphics

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `hardware.graphics.enable = true`
- `hardware.graphics.enable32Bit = true`
- `services.xserver.videoDrivers = [ "nvidia" ]`
- `hardware.nvidia.open = true`
- `hardware.nvidia.modesetting.enable = true`
- `hardware.nvidia.powerManagement.enable = false`
- `hardware.nvidia.nvidiaSettings = true`
- X server `screenSection` sets NVIDIA-specific monitor ordering and metamodes for three displays
- NVIDIA package is also installed via `config.hardware.nvidia.package`

Migration notes:

- this is highly host-specific and easy to break
- monitor layout and metamodes should remain in the host module

Likely future home:

- `modules/hosts/azula/configuration.nix`

## Session And Portal Settings

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- session `PATH` prepends `$HOME/bin`
- `XCURSOR_THEME = "Adwaita"`
- `xdg.portal.enable = true`
- portal default is `gtk`
- extra portal package is `xdg-desktop-portal-gtk`

Likely future home:

- first pass in host config
- later portal and session pieces may be candidates for a desktop feature module

## Fonts

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- default font packages enabled
- fontconfig enabled
- installed font packages:
  - `font-awesome`
  - `inconsolata`
  - `jetbrains-mono`
  - `source-code-pro`
  - `nerd-fonts.fira-code`
- default monospace fonts:
  - `JetBrains Mono`
  - `Source Code Pro`
  - `Inconsolata`

Likely future home:

- likely reusable as `modules/features/fonts.nix`
- keep in host config during first pass unless extraction is trivial

## Printing

Priority: `P2`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `services.printing.enable = true`

Likely future home:

- reusable feature module candidate

## Audio

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- PulseAudio disabled
- `security.rtkit.enable = true`
- PipeWire enabled
- PipeWire ALSA enabled
- PipeWire 32-bit ALSA enabled
- PipeWire Pulse enabled

Likely future home:

- reusable feature module candidate

## User And Privilege Model

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- explicit group `fedex` with `gid = 1000`
- user `fedex`:
  - normal user
  - description `Federico Martín Iachetti`
  - `uid = 1000`
  - primary group `fedex`
  - extra groups:
    - `docker`
    - `libvirtd`
    - `networkmanager`
    - `wheel`
    - `users`
  - shell is `pkgs.zsh`
  - no extra user packages currently listed here
- sudo for group `wheel` is passwordless via `NOPASSWD`

Migration notes:

- user identity is a future user-module boundary, but first pass can leave it in host config
- passwordless sudo is significant behavior and should not be lost

Likely future home:

- first pass in host config
- later `modules/users/fedex/default.nix`

## Enabled Programs

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `programs.firefox.enable = true`
- `programs.zsh.enable = true`
- `programs.npm.enable = true`
- `programs.nix-ld.enable = true`
- `programs.nix-ld.libraries = [ libyaml ]`
- `programs.steam.enable = true`
- Steam opens remote play and dedicated server firewall rules
- `programs._1password.enable = true`
- `programs._1password-gui.enable = true`
- `programs._1password-gui.polkitPolicyOwners = [ "fedex" ]`
- `programs.virt-manager.enable = true`
- `programs.weylus.enable = true`
- `programs.weylus.openFirewall = true`
- `programs.weylus.users = [ "fedex" ]`

Likely future home:

- mixed
- some stay host-specific due to user coupling or GPU/desktop dependence
- some may become feature modules later

## System Packages

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- the system package list is large and includes desktop apps, CLI tools, media tools, virtualization tools, and custom flake-provided packages
- notable packages that influence migration design:
  - `emacs-with-grammars`
  - `pkgs-master.opencode`
  - `ollama-cuda`
  - `virtiofsd`
  - `config.hardware.nvidia.package`
  - `claude-code`
  - `docker` and `docker-compose`
  - `dunst`, `rofi`, `arandr`, `feh`, `ghostty`, `kitty`, `terminator`, `tilda`
  - media stack such as `davinci-resolve`, `obs-studio`, `vlc`, `ffmpeg`
  - development tools such as `git`, `git-lfs`, `github-cli`, `ripgrep`, `jq`, `jdk21`, `gnumake`
  - service clients such as `jellyfin-*`, `slack`, `discord`, `telegram-desktop`, `ferdium`
  - work-specific tools such as `awscli2`, `openvpn`, `vault`, `nomad`

Migration notes:

- the exact package list should survive the first structural move even if we later reorganize ownership
- only a few packages are structurally special because they depend on custom flake wiring

Likely future home:

- mostly host config initially
- later split between host, user, and feature modules

## Docker And Container Behavior

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- rootless Docker is enabled
- Docker socket variable is set
- Docker daemon settings:
  - DNS forced to `1.1.1.1` and `8.8.8.8`
  - `experimental = true`
  - BuildKit enabled
- user `fedex` belongs to `docker`

Migration notes:

- this is important workstation behavior and should survive the first pass unchanged

Likely future home:

- first pass in host config
- later candidate for `modules/features/virtualisation/docker.nix`

## Virtualization

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `virtualisation.libvirtd.enable = true`
- `virtualisation.libvirtd.qemu.package = pkgs.qemu_kvm`
- `virtualisation.libvirtd.qemu.vhostUserPackages = [ pkgs.virtiofsd ]`
- user `fedex` belongs to `libvirtd`

Likely future home:

- first pass in host config
- later candidate for a virtualization feature module

## Services

Priority: `P1`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- `services.openssh.enable = true`
- `services.ollama`:
  - enabled
  - package `pkgs.ollama-cuda`
  - host `0.0.0.0`
  - port `11434`
  - `openFirewall = false`
  - environment variables:
    - `OLLAMA_HOST = "0.0.0.0"`
    - `OLLAMA_ORIGINS = "*"`
- `services.jellyfin`:
  - enabled
  - firewall opened
  - runs as user `fedex`
- `services.syncthing`:
  - enabled
  - user `fedex`
  - dataDir `/home/fedex/.local/share/syncthing`
  - configDir `/home/fedex/.config/syncthing`
  - opens default ports
- `services.qdrant`:
  - enabled
  - HTTP on `127.0.0.1:6333`
  - gRPC on `127.0.0.1:6334`
  - storage path `/var/lib/qdrant/storage`
- `services.nginx`:
  - enabled
  - recommended proxy settings enabled
  - recommended TLS settings enabled
  - recommended gzip settings enabled
  - recommended optimisation enabled
  - reverse proxy virtual hosts:
    - `jellyfin.omashu.org` -> `http://127.0.0.1:8096`
    - `kraken.omashu.org` -> `http://192.168.122.50:4568`
- `security.acme`:
  - terms accepted
  - email `fiachetti@omashu.com`

Migration notes:

- several of these are good later feature candidates, but they are also tied to this host's network and storage assumptions
- preserve exact ports and proxy targets on first pass

Likely future home:

- first pass in host config
- later possible extractions: `services/openssh`, `services/ollama`, maybe self-hosting modules

## Systemd Generator Workaround

Priority: `P0`

Source: `~/nixos-flakes/azula/configuration.nix`

Current behavior:

- defines a custom `systemdSystemGenerators` derivation
- forcefully sets `environment.etc."systemd/system-generators".source`
- purpose is to work around a nixpkgs regression when no package contributes generator files

Migration notes:

- this should move as-is during the structural migration
- removing it could break rebuilds on the current channel state

Likely future home:

- `modules/hosts/azula/configuration.nix`

## Flake Exports Beyond NixOS

Priority: `P2`

Source: `~/nixos-flakes/azula/flake.nix`

Current behavior:

- exports `packages.${system}` from `nixpkgs-ruby.packages.${system}`
- sets `default = nixpkgs-ruby.packages.${system}."ruby-4"`
- exports a `devShell` for each Ruby version
- each devShell includes Ruby plus native build dependencies such as `libyaml`, `openssl`, `zlib`, `readline`, `pkg-config`, `gcc`, `gnumake`, `libffi`, and `gtk3`
- each devShell sets `GEM_HOME`, `GEM_PATH`, `PATH`, and `LD_LIBRARY_PATH` in `shellHook`

Migration notes:

- these are not part of booting `azula`, but they are part of the flake's current external behavior
- structural migration should preserve them if we want the new top-level flake to fully replace the old one

Likely future home:

- top-level flake outputs or a flake module under `modules/`

## Initial Migration Priorities

Priority summary for Phase 1:

- `P0` preserve first:
  - inputs and overlays
  - `specialArgs`
  - NixOS module list
  - hardware import and filesystems
  - bootloader and IP forwarding
  - desktop stack
  - NVIDIA and monitor layout
  - user `fedex` and sudo model
  - Docker rootless behavior
  - systemd generator workaround
- `P1` preserve in the first structural pass if practical:
  - networking and firewall rules
  - locale/timezone/keyboard
  - fonts
  - audio
  - enabled programs
  - system packages
  - virtualization
  - services like Ollama, Jellyfin, Syncthing, nginx, qdrant, ACME
- `P2` track carefully but they can be separated later if needed:
  - printing
  - exported Ruby packages and devShells

## Recommended Next Edit

Priority: `P0`

Next code change should be structural, not behavioral:

1. create top-level `~/nixos-flakes/flake.nix` in the same thin style used by `~/myNixOS`
2. create `~/nixos-flakes/modules/parts.nix`
3. create `~/nixos-flakes/modules/hosts/azula/default.nix`
4. create `~/nixos-flakes/modules/hosts/azula/configuration.nix`
5. create `~/nixos-flakes/modules/hosts/azula/hardware.nix`

Rule for that step:

- move code with as little rewriting as possible
- preserve all `P0` items exactly
- do not extract reusable features yet unless a move is mechanically necessary
