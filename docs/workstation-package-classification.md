# Workstation Package Classification

Goal: split `modules/features/workstation.nix` into smaller exports, one category at a time, while keeping `myMachine` usable.

## Status Legend

- `pending`: not extracted yet
- `extracted`: moved to a dedicated module
- `duplicate`: already owned elsewhere in the repo
- `host-specific`: should stay in a host config
- `deferred`: intentionally left for later

## Categories

- `base`: session defaults and desktop baseline
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
| `programs.firefox.enable` | `workstation` | `base` | pending | Also appears in `toph`; likely host-specific in some cases. |
| `programs.zsh.enable` | `workstation` | `base` | pending | Also appears in `toph`; keep only where needed. |
| `environment.sessionVariables.PATH` | `workstation` | `base` | pending | Shell convenience. |
| `environment.sessionVariables.XCURSOR_THEME` | `workstation` | `base` | pending | Desktop preference. |
| `xdg.portal` / `xdg-desktop-portal-gtk` | `workstation` | `base` | pending | Desktop baseline. |
| `brave` | `workstation` | `browsers` | pending | Heavy browser. |
| `firefox-devedition` | `workstation` | `dev-browsers` | pending | Heavy browser. |
| `discord` | `workstation` | `chat` | pending | Chat app. |
| `ferdium` | `workstation` | `chat` | pending | Chat aggregator. |
| `slack` | `workstation` | `chat` | pending | Work chat. |
| `telegram-desktop` | `workstation` | `chat` | pending | Chat app. |
| `ghostty` | `workstation` | `terminals` | pending | Terminal app. Also used by `kalkomey`. |
| `kitty` | `workstation` | `terminals` | pending | Terminal app. |
| `tilda` | `workstation` | `terminals` | pending | Drop-down terminal. |
| `cheese` | `workstation` | `desktop-utils` | pending | Webcam utility. |
| `evince` | `workstation` | `desktop-utils` | pending | Document viewer. |
| `feh` | `workstation` | `desktop-utils` | pending | Image viewer. |
| `flameshot` | `workstation` | `desktop-utils` | pending | Screenshot tool. |
| `gnome-calculator` | `workstation` | `desktop-utils` | pending | Desktop utility. |
| `libnotify` | `workstation` | `desktop-utils` | pending | Notification helper. |
| `nemo` | `workstation` | `desktop-utils` | pending | File manager. |
| `pavucontrol` | `workstation` | `desktop-utils` | duplicate | Already in `pipewire`. |
| `xclip` | `workstation` | `desktop-utils` | pending | Clipboard helper. |
| `xhost` | `workstation` | `desktop-utils` | pending | X11 access helper. Also used by `kalkomey`. |
| `transmission_4-gtk` | `workstation` | `downloads` | pending | GUI download tool. |
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

## Suggested First Exports

1. `modules/features/workstation/base.nix` - extracted
2. `modules/features/workstation/dev.nix` - extracted
3. `modules/features/workstation/browsers.nix` - extracted
4. `modules/features/workstation/chat.nix` - extracted
5. `modules/features/workstation/terminals.nix` - extracted
6. `modules/features/workstation/desktop-utils.nix` - extracted
7. `modules/features/workstation/media.nix` - extracted
8. `modules/features/workstation/streaming.nix` - extracted
9. `modules/features/workstation/finance.nix` - extracted

## Notes

- Keep `myMachine` on the smallest useful subset first.
- Treat `ke`-owned packages as user/work-specific, not workstation-wide.
- Keep `pavucontrol` in `pipewire` and `virtiofsd` in `libvirt`.
- Move `docker` package ownership out of workstation if the Docker feature already enables the daemon.
