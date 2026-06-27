# Workstation Package Classification

Goal: track the workstation-to-top-level feature split while keeping `myMachine` usable.

## Status Legend

- `pending`: not extracted yet
- `extracted`: moved to a dedicated module
- `duplicate`: already owned elsewhere in the repo
- `host-specific`: should stay in a host config
- `deferred`: intentionally left for later

## Categories

- `workstation`: session defaults and desktop baseline
- `browsers`: browsers
- `dev-browsers`: browsers used for development workflows
- `chat`: chat and messaging apps
- `terminals`: terminal and launcher tools
- `desktop-utils`: desktop utilities and helpers
- `downloads`: download and transfer tools
- `media`: media, creative, and playback apps
- `server`: media server packages and server-adjacent clients
- `streaming`: recording and streaming tools
- `dev`: general development tools
- `finance`: accounting and personal finance tools
- `ops`: work and infrastructure tools
- `gaming`: games and game-related packages
- `security`: password and auth tools
- `remote-input`: tablet and remote control tools
- `ai`: AI / assistant tooling

## Inventory

| Package | Current owner | Proposed category | Status | Notes |
| --- | --- | --- | --- | --- |
| `programs.firefox.enable` | `workstation` | `workstation` | extracted | Also appears in `toph`; likely host-specific in some cases. |
| `programs.zsh.enable` | `workstation` | `workstation` | extracted | Also appears in `toph`; keep only where needed. |
| `environment.sessionVariables.PATH` | `workstation` | `workstation` | extracted | Shell convenience. |
| `environment.sessionVariables.XCURSOR_THEME` | `workstation` | `workstation` | extracted | Desktop preference. |
| `xdg.portal` / `xdg-desktop-portal-gtk` | `workstation` | `workstation` | extracted | Desktop baseline. |
| `brave` | `workstation` | `browsers` | extracted | Heavy browser. |
| `firefox-devedition` | `workstation` | `browsers` | extracted | Heavy browser. |
| `discord` | `workstation` | `chat` | extracted | Chat app. |
| `ferdium` | `workstation` | `chat` | extracted | Chat aggregator. |
| `slack` | `workstation` | `chat` | extracted | Work chat. |
| `telegram-desktop` | `workstation` | `chat` | extracted | Chat app. |
| `ghostty` | `workstation` | `terminals` | extracted | Terminal app. Also used by `kalkomey`. |
| `kitty` | `workstation` | `terminals` | extracted | Terminal app. |
| `tilda` | `workstation` | `terminals` | extracted | Drop-down terminal. |
| `cheese` | `workstation` | `desktop-utils` | extracted | Webcam utility. |
| `evince` | `workstation` | `desktop-utils` | extracted | Document viewer. |
| `feh` | `workstation` | `desktop-utils` | extracted | Image viewer. |
| `flameshot` | `workstation` | `desktop-utils` | extracted | Screenshot tool. |
| `gnome-calculator` | `workstation` | `desktop-utils` | extracted | Desktop utility. |
| `libnotify` | `workstation` | `desktop-utils` | extracted | Notification helper. |
| `nemo` | `workstation` | `desktop-utils` | extracted | File manager. |
| `pavucontrol` | `pipewire` | `desktop-utils` | duplicate | Already in `pipewire`. |
| `xclip` | `workstation` | `desktop-utils` | extracted | Clipboard helper. |
| `xhost` | `workstation` | `desktop-utils` | extracted | X11 access helper. Also used by `kalkomey`. |
| `transmission_4-gtk` | `workstation` | `desktop-utils` | extracted | GUI download tool. |
| `audacity` | `workstation` | `media` | extracted | Audio editor. |
| `ffmpeg` | `workstation` | `media` | extracted | Media backend. |
| `vlc` | `workstation` | `media` | extracted | Media player. |
| `jellyfin-ffmpeg` | `server` | `media` | extracted | Media backend. |
| `jellyfin-media-player` | `server` | `media` | extracted | Client app. |
| `jellyfin-desktop` | `server` | `media` | extracted | Client app. |
| `jellyfin` | `server` | `media` | extracted | Client/app bundle. Service ownership stays in hosts. |
| `jellyfin-web` | `server` | `media` | extracted | Client app. |
| `obs-studio` | `workstation` | `streaming` | extracted | Recording/streaming. |
| `cargo` | `workstation` | `dev` | extracted | Rust toolchain helper. |
| `difftastic` | `workstation` | `dev` | extracted | Diff tool. |
| `entr` | `workstation` | `dev` | extracted | File watcher. |
| `graphviz` | `workstation` | `dev` | extracted | Diagramming. |
| `jdk21` | `workstation` | `dev` | extracted | Java toolchain. |
| `python3Packages.weasyprint` | `workstation` | `dev` | extracted | Document rendering. |
| `rustc` | `workstation` | `dev` | extracted | Rust toolchain. |
| `git-lfs` | `workstation` | `dev` | extracted | Git extension. |
| `unzip` | `workstation` | `dev` | extracted | Archive utility. |
| `vim` | `workstation` | `dev` | extracted | Editor. |
| `watchman` | `workstation` | `dev` | extracted | File watching service. |
| `hledger` | `workstation` | `finance` | extracted | Accounting tools. |
| `hledger-interest` | `workstation` | `finance` | extracted | Accounting tools. |
| `hledger-ui` | `workstation` | `finance` | extracted | Accounting tools. |
| `hledger-web` | `workstation` | `finance` | extracted | Accounting tools. |
| `ledger` | `workstation` | `finance` | extracted | Accounting tools. |
| `docker` | `docker` | `ops` | extracted | Docker CLI now lives with the Docker feature. |
| `docker-compose` | `docker` | `ops` | extracted | Docker CLI now lives with the Docker feature. |
| `lazydocker` | `docker` | `ops` | extracted | Docker UI now lives with the Docker feature. |
| `awscli2` | `users.ke` | `ops` | duplicate | Already in `users.ke`. |
| `nomad` | `users.ke` | `ops` | duplicate | Already in `users.ke`. |
| `openvpn` | `users.ke` | `ops` | duplicate | Already in `users.ke`. |
| `vault` | `users.ke` | `ops` | duplicate | Already in `users.ke`. |
| `godot` | `workstation` | `gaming` | extracted | Game engine. |
| `steam` | `workstation` via module | `gaming` | extracted | Already exported as `steam`. |
| `onepassword` | `workstation` via module | `security` | extracted | Already exported as `onepassword`. |
| `weylus` | `workstation` via module | `remote-input` | extracted | Already exported as `weylus`. |
| `claude-code` | `workstation` | `ai` | extracted | AI assistant CLI. |
| `opencode` | separate module | `ai` | extracted | Already exported as `opencode`. |

## Current Top-Level Modules

- `workstation`
- `browsers`
- `chat`
- `terminals`
- `desktopUtils`
- `workstationDev`
- `finance`
- `media`
- `streaming`
- `claudeCode`
- `godot`
- `jellyfin`
- `steam`
- `onepassword`
- `weylus`

## Notes

- Keep `myMachine` on the smallest useful subset first.
- Treat `ke`-owned packages as user/work-specific, not workstation-wide.
- Keep `pavucontrol` in `pipewire` and `virtiofsd` in `libvirt`.
- Move `docker` package ownership out of workstation if the Docker feature already enables the daemon.
