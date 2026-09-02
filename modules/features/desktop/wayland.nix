{ ... }: {
  flake.nixosModules.wayland =
    { pkgs, lib, config, ... }:
    let
      colors = {
        bg = "#0A1420";
        bgAlt = "#102033";
        surface = "#17324D";
        focus = "#2E5F8A";
        accent = "#4EA5D9";
        focusBorder = "#1C3F5E";
        nextHint = "#3A78A8";
        text = "#D8E9F7";
        muted = "#89A8C2";
        urgent = "#B23A48";
      };

      terminal = lib.getExe pkgs.ghostty;
      launcher = "${lib.getExe pkgs.rofi} -show run";
      privilegedLauncher = "sudo ${launcher}";
      windowSwitcher = "${lib.getExe pkgs.rofi} -show window";
      fileBookmarks = "/home/fedex/bin/file-bookmarks";
      webBookmarks = "/home/fedex/bin/web-bookmarks";
      braveBookmarks = "/home/fedex/bin/web-bookmarks-brave";
      profileBrowser = "${lib.getExe pkgs.firefox} --no-remote -P razor-profile";
      browser = "${lib.getExe pkgs.firefox}";
      browserDev = "${lib.getExe pkgs.firefox-devedition}";
      calculator = "${lib.getExe pkgs.gnome-calculator}";
      telegram = lib.getExe pkgs.telegram-desktop;
      orlandoTracker = "/home/fedex/code/orlando-market-notification/orlando-tracker ORL-2026-940004 ORL-2026-130166";

      hyprMoveAndFollow = pkgs.writeShellApplication {
        name = "hyprland-move-and-follow";
        runtimeInputs = [ pkgs.hyprland ];
        text = ''
          set -eu
          workspace=$1
          hyprctl dispatch movetoworkspace "$workspace"
          hyprctl dispatch workspace "$workspace"
        '';
      };

      waybarLauncher = pkgs.writeShellApplication {
        name = "waybar-launch";
        runtimeInputs = [
          pkgs.procps
          pkgs.waybar
        ];
        text = ''
          set -eu
          if pgrep -x waybar >/dev/null 2>&1; then
            exit 0
          fi

          case "''${XDG_CURRENT_DESKTOP:-''${XDG_SESSION_DESKTOP:-}}" in
            Hyprland*)
              config=/etc/xdg/waybar/hyprland.jsonc
              ;;
            sway*|Sway*)
              config=/etc/xdg/waybar/sway.jsonc
              ;;
            *)
              config=/etc/xdg/waybar/sway.jsonc
              ;;
          esac

          exec waybar -c "$config" -s /etc/xdg/waybar/style.css
        '';
      };

      waybarToggle = pkgs.writeShellApplication {
        name = "waybar-toggle";
        runtimeInputs = [
          pkgs.procps
          waybarLauncher
        ];
        text = ''
          set -eu
          if pgrep -x waybar >/dev/null 2>&1; then
            pkill -x waybar
          else
            ${lib.getExe waybarLauncher} >/dev/null 2>&1 &
          fi
        '';
      };

      waylandLock = pkgs.writeShellApplication {
        name = "wayland-lock";
        runtimeInputs = [ pkgs.swaylock ];
        text = ''
          set -eu
          exec swaylock --daemonize --indicator --clock --datestr '%Y-%m-%d' --timestr '%H:%M' --font 'URWGothic' --font-size 24 --color ${colors.bg} --inside-color ${colors.surface}CC --inside-clear-color ${colors.surface}CC --inside-ver-color ${colors.focus}CC --inside-wrong-color ${colors.urgent}CC --ring-color ${colors.focusBorder}FF --ring-clear-color ${colors.focusBorder}FF --ring-ver-color ${colors.accent}FF --ring-wrong-color ${colors.urgent}FF --line-color ${colors.bg}00 --separator-color ${colors.nextHint}FF --text-color ${colors.text}FF --text-clear-color ${colors.text}FF --text-ver-color ${colors.text}FF --text-wrong-color ${colors.text}FF
        '';
      };

      waylandPower = pkgs.writeShellApplication {
        name = "wayland-power-menu";
        runtimeInputs = [
          pkgs.rofi
          pkgs.systemd
          waylandLock
        ];
        text = ''
          set -eu
          choice=$(printf '%s\n' lock sleep hibernate reboot shutdown logout | ${lib.getExe pkgs.rofi} -dmenu -p power)
          case "$choice" in
            lock) ${lib.getExe waylandLock} ;;
            sleep) systemctl suspend ;;
            hibernate) systemctl hibernate ;;
            reboot) systemctl reboot ;;
            shutdown) systemctl poweroff ;;
            logout)
              if [ -n "''${XDG_SESSION_ID:-}" ]; then
                loginctl terminate-session "''${XDG_SESSION_ID}"
              fi
              ;;
            *) exit 0 ;;
          esac
        '';
      };

      waylandScreenshot = pkgs.writeShellApplication {
        name = "wayland-screenshot";
        runtimeInputs = [
          pkgs.grim
          pkgs.slurp
          pkgs.wl-clipboard
          pkgs.libnotify
        ];
        text = ''
          set -eu
          target=$(slurp)
          grim -g "$target" - | wl-copy
          notify-send 'Screenshot copied' 'Selection copied to the clipboard.'
        '';
      };

      desktopSessionCommon = pkgs.writeShellApplication {
        name = "desktop-session-common";
        runtimeInputs = [
          pkgs.procps
          pkgs.mako
          pkgs.swaybg
          pkgs.networkmanagerapplet
          pkgs.polkit_gnome
          pkgs.swayidle
          waybarLauncher
        ];
        text = ''
          set -eu

          start_once() {
            name=$1
            shift
            if pgrep -x "$name" >/dev/null 2>&1; then
              return 0
            fi
            "$@" >/dev/null 2>&1 &
          }

          start_once_full() {
            pattern=$1
            shift
            if pgrep -f "$pattern" >/dev/null 2>&1; then
              return 0
            fi
            "$@" >/dev/null 2>&1 &
          }

          if command -v mako >/dev/null 2>&1; then
            start_once mako ${lib.getExe pkgs.mako}
          fi

          ${lib.getExe waybarLauncher} >/dev/null 2>&1 &

          if command -v swaybg >/dev/null 2>&1; then
            start_once swaybg ${lib.getExe pkgs.swaybg} -i "$HOME/Pictures/miles.png" -m fill
          fi

          if command -v nm-applet >/dev/null 2>&1; then
            start_once nm-applet ${lib.getExe' pkgs.networkmanagerapplet "nm-applet"}
          fi

          if command -v polkit-gnome-authentication-agent-1 >/dev/null 2>&1; then
            start_once_full '[p]olkit-gnome-authentication-agent-1' ${lib.getExe' pkgs.polkit_gnome "polkit-gnome-authentication-agent-1"}
          fi

          if command -v swayidle >/dev/null 2>&1; then
            start_once swayidle swayidle -w timeout 1800 ${lib.getExe waylandLock} before-sleep ${lib.getExe waylandLock}
          fi
        '';
      };

      paletteCss = ''
        * {
          border: none;
          border-radius: 0;
          min-height: 0;
          font-family: URWGothic, "DejaVu Sans", sans-serif;
          font-size: 11px;
        }

        window#waybar {
          background: ${colors.bg};
          color: ${colors.text};
          border-top: 1px solid ${colors.focusBorder};
        }

        #custom-launcher,
        #custom-power,
        #clock,
        #tray,
        #network,
        #pulseaudio,
        #backlight,
        #mode,
        #window,
        #workspaces button {
          padding: 0 8px;
          margin: 0;
        }

        #workspaces button {
          background: ${colors.bgAlt};
          color: ${colors.muted};
        }

        #workspaces button.focused,
        #workspaces button.active,
        #workspaces button.visible {
          background: ${colors.focus};
          color: ${colors.text};
        }

        #workspaces button.urgent,
        #mode {
          background: ${colors.urgent};
          color: ${colors.text};
        }

        #custom-launcher,
        #custom-power,
        #clock,
        #tray,
        #network,
        #pulseaudio,
        #backlight,
        #window {
          background: ${colors.bgAlt};
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }
      '';

      mkWaybarConfig =
        workspaceModule: extraLeft:
        builtins.toJSON {
          layer = "top";
          position = "bottom";
          exclusive = true;
          height = 26;
          spacing = 4;
          "modules-left" = [
            "custom/launcher"
            workspaceModule
          ]
          ++ extraLeft;
          "modules-center" = [ "clock" ];
          "modules-right" = [
            "backlight"
            "pulseaudio"
            "network"
            "tray"
            "custom/power"
          ];
          "custom/launcher" = {
            format = "⌘";
            tooltip = false;
            on-click = launcher;
          };
          "custom/power" = {
            format = "⏻";
            tooltip = false;
            on-click = "${lib.getExe waylandPower}";
          };
          clock = {
            format = "{:%a %d %b  %H:%M}";
            tooltip = false;
          };
          tray = {
            spacing = 8;
          };
          backlight = {
            format = " {percent}%";
          };
          pulseaudio = {
            format = " {volume}%";
            "format-muted" = " muted";
          };
          network = {
            "format-wifi" = "󰖩 {essid}";
            "format-ethernet" = "󰈀 wired";
            "format-disconnected" = "󰤭 offline";
          };
        };

      mkWorkspaceNames = [
        "1"
        "2"
        "3"
        "4"
        "5"
        "6"
        "7"
        "8"
        "9"
        "10"
        "💬"
        "🐙"
        "📞"
        "📥"
        "🎬"
      ];
      mkSwayWorkspaceFocus =
        prefix:
        lib.concatStringsSep "\n" (
          lib.imap0 (index: name: ''
            bindsym ${prefix}+${if index == 9 then "0" else toString (index + 1)} workspace ${name}
          '') (lib.take 10 mkWorkspaceNames)
        );

      mkSwayWorkspaceMove =
        prefix:
        lib.concatStringsSep "\n" (
          lib.imap0 (index: name: ''
            bindsym ${prefix}+${
              if index == 9 then "0" else toString (index + 1)
            } move container to workspace ${name}; workspace ${name}
          '') (lib.take 10 mkWorkspaceNames)
        );

      mkHyprWorkspaceFocusBinds =
        prefix:
        lib.concatStringsSep "\n" (
          lib.imap0 (index: name: ''
            bind = ${prefix}, ${if index == 9 then "0" else toString (index + 1)}, workspace, ${name}
          '') (lib.take 10 mkWorkspaceNames)
        );

      mkHyprWorkspaceMoveBinds =
        prefix:
        lib.concatStringsSep "\n" (
          lib.imap0 (index: name: ''
            bind = ${prefix}, ${if index == 9 then "0" else toString (index + 1)}, exec, ${lib.getExe hyprMoveAndFollow} ${lib.escapeShellArg name}
          '') (lib.take 10 mkWorkspaceNames)
        );

      swayConfig = ''
        set $mod Mod4

        default_border pixel 1
        default_floating_border normal
        hide_edge_borders none
        font pango:URWGothic 11
        floating_modifier $mod
        workspace_auto_back_and_forth yes
        gaps inner 0
        gaps outer 0
        smart_gaps off
        smart_borders on

        set $blue_bg ${colors.bg}
        set $blue_bg_alt ${colors.bgAlt}
        set $blue_surface ${colors.surface}
        set $blue_focus ${colors.focus}
        set $blue_accent ${colors.accent}
        set $blue_focus_border ${colors.focusBorder}
        set $blue_next_hint ${colors.nextHint}
        set $blue_text ${colors.text}
        set $blue_muted ${colors.muted}
        set $blue_urgent ${colors.urgent}

        bindsym $mod+Return exec ${terminal}
        bindsym $mod+Shift+q kill
        bindsym $mod+d exec ${launcher}
        bindsym $mod+Shift+d exec ${launcher}
        bindsym Mod1+Shift+Tab exec ${windowSwitcher}
        bindsym $mod+g exec ${fileBookmarks}
        bindsym $mod+b exec ${webBookmarks}
        bindsym $mod+Shift+b exec ${braveBookmarks}
        bindsym $mod+j exec ${profileBrowser}
        bindsym $mod+e exec emacsclient -c -a emacs
        bindsym $mod+Shift+e exec emacs --debug-init /home/fedex/.emacs.d/Readme.org
        bindsym $mod+c exec ${browser}
        bindsym $mod+Shift+c exec ${browserDev}
        bindsym $mod+k kill
        bindsym $mod+m exec ${lib.getExe waybarToggle}

        bindsym $mod+Left focus left
        bindsym $mod+Down focus down
        bindsym $mod+Up focus up
        bindsym $mod+Right focus right

        bindsym $mod+Shift+Left move left
        bindsym $mod+Shift+Down move down
        bindsym $mod+Shift+Up move up
        bindsym $mod+Shift+Right move right

        bindsym $mod+bracketleft move workspace to output left
        bindsym $mod+bracketright move workspace to output right

        bindsym $mod+h splith
        bindsym $mod+v splitv
        bindsym $mod+q layout toggle split
        bindsym $mod+f fullscreen toggle
        bindsym $mod+s layout stacking
        bindsym $mod+t layout tabbed
        bindsym $mod+w layout toggle split
        bindsym $mod+Shift+space floating toggle
        bindsym $mod+space focus mode_toggle
        bindsym $mod+Shift+s sticky toggle
        bindsym $mod+a focus parent

        bindsym $mod+Shift+minus move scratchpad
        bindsym $mod+minus scratchpad show
        bindsym $mod+slash exec /home/fedex/bin/scratchpad_windows

        bindsym $mod+Ctrl+Right workspace next
        bindsym $mod+Ctrl+Left workspace prev

        ${mkSwayWorkspaceFocus "$mod"}
        ${mkSwayWorkspaceMove "$mod+Shift"}

        bindsym $mod+F1 workspace "💬"
        bindsym $mod+Shift+F1 move container to workspace "💬"; workspace "💬"
        bindsym $mod+F2 workspace "🐙"
        bindsym $mod+Shift+F2 move container to workspace "🐙"; workspace "🐙"
        bindsym $mod+F3 workspace "📞"
        bindsym $mod+Shift+F3 move container to workspace "📞"; workspace "📞"
        bindsym $mod+F12 workspace "📥"
        bindsym $mod+Shift+F12 move container to workspace "📥"; workspace "📥"
        bindsym $mod+F5 workspace "🎬"
        bindsym $mod+Shift+F5 move container to workspace "🎬"; workspace "🎬"

        assign [class="TelegramDesktop"] workspace "💬"
        assign [class="Slack"] workspace "💬"
        assign [class="Keybase"] workspace "💬"
        assign [class="discord"] workspace "💬"
        assign [class="Whatsapp-for-linux"] workspace "💬"
        assign [class="Signal"] workspace "💬"
        assign [class="Ferdium"] workspace "💬"
        assign [app_id="org.telegram.desktop"] workspace "💬"
        assign [app_id="discord"] workspace "💬"

        for_window [class="(?i)System-config-printer.py"] floating enable border normal
        for_window [class="1Password"] floating enable, sticky enable
        for_window [class="Cheese"] floating enable
        for_window [class="Clipgrab"] floating enable
        for_window [class="Clockify"] floating enable
        for_window [class="GParted"] floating enable border normal
        for_window [class="Galculator"] floating enable border pixel 1
        for_window [class="Gnome-calculator"] floating enable sticky enable
        for_window [class="Lightdm-settings"] floating enable
        for_window [class="Lxappearance"] floating enable sticky enable border normal
        for_window [class="Manjaro Settings Manager"] floating enable border normal
        for_window [class="Manjaro-hello"] floating enable
        for_window [class="Nitrogen"] floating enable sticky enable border normal
        for_window [class="NoiseTorch"] floating enable
        for_window [class="Oblogout"] fullscreen enable
        for_window [class="Pamac-manager"] floating enable
        for_window [class="pavucontrol"] floating enable, sticky enable, move scratchpad
        for_window [class="QjackCtl"] floating enable
        for_window [class="Qtconfig-qt4"] floating enable sticky enable border normal
        for_window [class="Shutter"] floating enable sticky enable
        for_window [class="Simple-scan"] floating enable border normal
        for_window [class="Skype"] floating enable border normal
        for_window [class="Surf"] floating enable
        for_window [class="Timeset-gui"] floating enable border normal
        for_window [class="Tk"] floating enable
        for_window [class="Tuple"] floating enable
        for_window [class="VirtualBox Machine"] floating disable
        for_window [class="Xfburn"] floating enable
        for_window [class="calamares"] floating enable border normal
        for_window [class="fpakman"] floating enable
        for_window [class="gnome-calculator"] floating enable sticky enable
        for_window [class="octopi"] floating enable
        for_window [class="qt5ct"] floating enable sticky enable border normal
        for_window [class="zoom"] floating enable
        for_window [title="File Transfer*"] floating enable
        for_window [title="MuseScore: Play Panel"] floating enable
        for_window [title="alsamixer"] floating enable border pixel 1
        for_window [title="i3_help"] floating enable sticky enable border normal
        for_window [title="floating"] floating enable
        for_window [class="Vmware"] border normal

        for_window [urgent=latest] focus

        bindsym $mod+Shift+r reload
        bindsym $mod+Shift+F9 mode "$mode_system"
        set $mode_system (l)ock, (e)xit, switch_(u)ser, (s)suspend, (h)ibernate, (r)eboot, (Shift+s)hutdown
        mode "$mode_system" {
          bindsym l exec ${lib.getExe waylandLock}, mode "default"
          bindsym s exec systemctl suspend, mode "default"
          bindsym u exec loginctl terminate-session "$XDG_SESSION_ID", mode "default"
          bindsym e exec swaymsg exit, mode "default"
          bindsym h exec systemctl hibernate, mode "default"
          bindsym r exec systemctl reboot, mode "default"
          bindsym Shift+s exec systemctl poweroff, mode "default"
          bindsym Return mode "default"
          bindsym Escape mode "default"
        }

        bindsym $mod+r mode "resize"
        mode "resize" {
          bindsym j resize shrink width 5 px or 5 ppt
          bindsym k resize grow height 5 px or 5 ppt
          bindsym l resize shrink height 5 px or 5 ppt
          bindsym semicolon resize grow width 5 px or 5 ppt
          bindsym Left resize shrink width 5 px or 5 ppt
          bindsym Down resize grow height 5 px or 5 ppt
          bindsym Up resize shrink height 5 px or 5 ppt
          bindsym Right resize grow width 5 px or 5 ppt
          bindsym Return mode "default"
          bindsym Escape mode "default"
        }

        bindsym $mod+shift+l exec ${lib.getExe waylandLock}
        bindsym $mod+l exec ${lib.getExe waylandLock}

        exec ${lib.getExe desktopSessionCommon}
        workspace 1
        exec sh -c 'command -v emacsclient >/dev/null 2>&1 && exec emacsclient -c -a emacs'
        exec sh -c 'command -v pavucontrol >/dev/null 2>&1 && exec ${lib.getExe pkgs.pavucontrol}'
        exec sh -c 'command -v 1password >/dev/null 2>&1 && exec ${lib.getExe pkgs._1password-gui}'
        exec sh -c 'command -v morgen >/dev/null 2>&1 && exec morgen'
        workspace 3
        exec sh -c 'command -v firefox >/dev/null 2>&1 && exec ${browser}'
        workspace 1
        exec ${telegram}
        exec sh -c 'command -v discord >/dev/null 2>&1 && exec discord'
        exec sh -c 'command -v ferdium >/dev/null 2>&1 && exec ferdium'
        exec sh -c 'command -v slack >/dev/null 2>&1 && exec slack'
        workspace 1

        bindsym Print exec ${lib.getExe waylandScreenshot}
        bindsym XF86Calculator exec ${calculator}
        bindsym XF86MonBrightnessDown exec brightnessctl set 10%-
        bindsym XF86MonBrightnessUp exec brightnessctl set 10%+

        bindsym button8 exec notify-send "button8"
        bindsym button9 exec notify-send "button9"

        bindsym --release button2 kill

        bar {
          mode invisible
        }

        client.focused          ${colors.focusBorder} ${colors.bgAlt} ${colors.text} ${colors.nextHint} ${colors.focusBorder}
        client.focused_inactive ${colors.surface} ${colors.bgAlt} ${colors.text} ${colors.surface} ${colors.surface}
        client.unfocused        ${colors.bgAlt} ${colors.bgAlt} ${colors.muted} ${colors.bgAlt} ${colors.bgAlt}
        client.urgent           ${colors.urgent} ${colors.urgent} ${colors.text} ${colors.urgent} ${colors.urgent}
        client.placeholder      #000000 #0c0c0c #ffffff #000000
        client.background       ${colors.bg}
      '';

      hyprConfig = ''
        $mainMod = SUPER
        $terminal = ${terminal}
        $menu = ${launcher}
        $privilegedMenu = ${privilegedLauncher}
        $windowMenu = ${windowSwitcher}
        $lock = ${lib.getExe waylandLock}
        $screenshot = ${lib.getExe waylandScreenshot}

        monitor = DP-5, 2560x1080, 0x0, 1
        monitor = DP-0, 3840x2160, 2560x0, 1
        monitor = DP-3, 1920x1080, 6400x0, 1

        general {
          gaps_in = 0
          gaps_out = 0
          border_size = 1
          col.active_border = rgba(1C3F5EFF)
          col.inactive_border = rgba(17324DFF)
          layout = dwindle
        }

        decoration {
          rounding = 0

          shadow {
            enabled = false
          }
        }

        animations {
          enabled = true
          bezier = snappy, 0.15, 0.9, 0.1, 1.0

          animation = global, 1, 4, snappy
          animation = border, 1, 3, snappy
          animation = windows, 1, 4, snappy
          animation = fade, 1, 2, default
          animation = workspaces, 1, 3, default, slide
        }

        misc {
          disable_hyprland_logo = true
          focus_on_activate = true
        }

        dwindle {
          preserve_split = true
        }

        input {
          kb_layout = us
          kb_variant = intl
        }

        binds {
          workspace_back_and_forth = true
        }

        exec-once = ${lib.getExe desktopSessionCommon}
        exec-once = [workspace 1 silent] sh -c 'command -v emacsclient >/dev/null 2>&1 && exec emacsclient -c -a emacs'
        exec-once = [workspace 1 silent] sh -c 'command -v pavucontrol >/dev/null 2>&1 && exec ${lib.getExe pkgs.pavucontrol}'
        exec-once = [workspace 1 silent] sh -c 'command -v 1password >/dev/null 2>&1 && exec ${lib.getExe pkgs._1password-gui}'
        exec-once = [workspace 1 silent] sh -c 'command -v morgen >/dev/null 2>&1 && exec morgen'
        exec-once = [workspace 3 silent] sh -c 'command -v firefox >/dev/null 2>&1 && exec ${browser}'
        exec-once = ${telegram}
        exec-once = sh -c 'command -v discord >/dev/null 2>&1 && exec discord'
        exec-once = sh -c 'command -v ferdium >/dev/null 2>&1 && exec ferdium'
        exec-once = sh -c 'command -v slack >/dev/null 2>&1 && exec slack'

        bind = $mainMod, Return, exec, $terminal
        bind = $mainMod, Q, layoutmsg, togglesplit
        bind = $mainMod SHIFT, Q, killactive,
        bind = $mainMod, D, exec, $menu
        bind = $mainMod SHIFT, D, exec, $privilegedMenu
        bind = ALT SHIFT, Tab, exec, $windowMenu
        bind = $mainMod, G, exec, ${fileBookmarks}
        bind = $mainMod, B, exec, ${webBookmarks}
        bind = $mainMod SHIFT, B, exec, ${braveBookmarks}
        bind = $mainMod, J, exec, ${profileBrowser}
        bind = $mainMod, E, exec, emacsclient -c -a emacs
        bind = $mainMod SHIFT, E, exec, emacs --debug-init /home/fedex/.emacs.d/Readme.org
        bind = $mainMod, C, exec, ${browser}
        bind = $mainMod SHIFT, C, exec, ${browserDev}
        bind = $mainMod, K, killactive,
        bind = $mainMod, F10, exec, ${orlandoTracker}

        bind = $mainMod, Left, movefocus, l
        bind = $mainMod, Down, movefocus, d
        bind = $mainMod, Up, movefocus, u
        bind = $mainMod, Right, movefocus, r

        bind = $mainMod SHIFT, Left, movewindow, l
        bind = $mainMod SHIFT, Down, movewindow, d
        bind = $mainMod SHIFT, Up, movewindow, u
        bind = $mainMod SHIFT, Right, movewindow, r

        bind = $mainMod, bracketleft, movecurrentworkspacetomonitor, left
        bind = $mainMod, bracketright, movecurrentworkspacetomonitor, right

        bind = $mainMod, H, layoutmsg, togglesplit
        bind = $mainMod, V, togglegroup
        bind = $mainMod, F, fullscreen, 0
        bind = $mainMod, S, layoutmsg, togglesplit
        bind = $mainMod, T, togglegroup
        bind = $mainMod, W, layoutmsg, togglesplit
        bind = $mainMod SHIFT, SPACE, togglefloating,
        bind = $mainMod, SPACE, cyclenext, floating
        bind = $mainMod SHIFT, S, pin
        bind = $mainMod, A, exec, $windowMenu

        bind = $mainMod SHIFT, minus, movetoworkspace, special:scratch
        bind = $mainMod, minus, togglespecialworkspace, scratch
        bind = $mainMod, slash, exec, /home/fedex/bin/scratchpad_windows

        bind = $mainMod CTRL, Right, workspace, +1
        bind = $mainMod CTRL, Left, workspace, -1

        ${mkHyprWorkspaceFocusBinds "$mainMod"}
        ${mkHyprWorkspaceMoveBinds "$mainMod SHIFT"}

        bind = $mainMod, F1, workspace, name:💬
        bind = $mainMod SHIFT, F1, exec, ${lib.getExe hyprMoveAndFollow} ${lib.escapeShellArg "name:💬"}
        bind = $mainMod, F2, workspace, name:🐙
        bind = $mainMod SHIFT, F2, exec, ${lib.getExe hyprMoveAndFollow} ${lib.escapeShellArg "name:🐙"}
        bind = $mainMod, F3, workspace, name:📞
        bind = $mainMod SHIFT, F3, exec, ${lib.getExe hyprMoveAndFollow} ${lib.escapeShellArg "name:📞"}
        bind = $mainMod, F12, workspace, name:📥
        bind = $mainMod SHIFT, F12, exec, ${lib.getExe hyprMoveAndFollow} ${lib.escapeShellArg "name:📥"}
        bind = $mainMod, F5, workspace, name:🎬
        bind = $mainMod SHIFT, F5, exec, ${lib.getExe hyprMoveAndFollow} ${lib.escapeShellArg "name:🎬"}

        windowrule = match:class ^(TelegramDesktop|Slack|Keybase|discord|Whatsapp-for-linux|Signal|Ferdium)$, workspace name:💬
        windowrule = match:title ^(Telegram|Discord|Slack)$, workspace name:💬
        windowrule = match:class ^(1Password|Cheese|Clipgrab|Clockify|GParted|Galculator|Gnome-calculator|Lightdm-settings|Manjaro-hello|NoiseTorch|Pamac-manager|pavucontrol|QjackCtl|Surf|Tk|Tuple|Xfburn|fpakman|octopi|qt5ct|zoom)$, float on
        windowrule = match:class ^(1Password|Gnome-calculator|qt5ct)$, pin on
        windowrule = match:class ^VirtualBox Machine$, float off
        windowrule = match:class ^Oblogout$, fullscreen on
        windowrule = match:title ^(File Transfer.*|MuseScore: Play Panel|alsamixer|i3_help|floating)$, float on

        bind = $mainMod SHIFT, R, exec, hyprctl reload
        bind = $mainMod SHIFT, F9, submap, power
        submap = power
        bind = , L, exec, $lock, submap, reset
        bind = , S, exec, systemctl suspend, submap, reset
        bind = , U, exec, loginctl terminate-session "$XDG_SESSION_ID", submap, reset
        bind = , E, exec, hyprctl dispatch exit, submap, reset
        bind = , H, exec, systemctl hibernate, submap, reset
        bind = , R, exec, systemctl reboot, submap, reset
        bind = SHIFT, S, exec, systemctl poweroff, submap, reset
        bind = , Escape, submap, reset
        bind = , Return, submap, reset

        bind = $mainMod, R, submap, resize
        submap = resize
        bind = , J, resizeactive, -10 0
        bind = , K, resizeactive, 0 10
        bind = , L, resizeactive, 10 0
        bind = , Semicolon, resizeactive, 0 -10
        bind = , Left, resizeactive, -10 0
        bind = , Down, resizeactive, 0 10
        bind = , Up, resizeactive, 0 -10
        bind = , Right, resizeactive, 10 0
        bind = , Escape, submap, reset
        bind = , Return, submap, reset

        bind = , Print, exec, $screenshot
        bind = , XF86Calculator, exec, ${calculator}
        bind = , XF86MonBrightnessDown, exec, brightnessctl set 10%-
        bind = , XF86MonBrightnessUp, exec, brightnessctl set 10%+

        bindr = , mouse:274, killactive,
        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow

        bind = , mouse:8, exec, notify-send button8
        bind = , mouse:9, exec, notify-send button9
        bind = , mouse:10, exec, notify-send button10
        bind = , mouse:11, exec, notify-send button11
        bind = , mouse:12, exec, notify-send button12

      '';

    in
    lib.mkIf (config.networking.hostName == "azula") {
      services.displayManager.sddm.enable = true;
      services.xserver.displayManager.lightdm.enable = lib.mkForce false;
      services.displayManager.autoLogin.enable = lib.mkForce false;

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      programs.sway.enable = true;
      programs.sway.extraOptions = [ "--unsupported-gpu" ];

      services.gnome.gnome-keyring.enable = true;

      xdg.portal = {
        enable = true;
        config.common.default = [ "gtk" ];
        config.hyprland.default = [
          "hyprland"
          "gtk"
        ];
        config.sway."org.freedesktop.impl.portal.ScreenCast" = lib.mkForce [ "wlr" ];
        config.sway."org.freedesktop.impl.portal.Screenshot" = lib.mkForce [ "wlr" ];
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          xdg-desktop-portal-hyprland
          xdg-desktop-portal-wlr
        ];
      };

      environment.systemPackages = with pkgs; [
        brightnessctl
        gnome-calculator
        grim
        libnotify
        mako
        networkmanagerapplet
        playerctl
        pavucontrol
        polkit_gnome
        rofi
        slurp
        swaybg
        swayidle
        swaylock
        waybar
        wl-clipboard
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-wlr
        waylandLock
        waylandPower
        waylandScreenshot
        waybarLauncher
        waybarToggle
        hyprMoveAndFollow
      ];

      environment.etc."xdg/waybar/style.css".text = paletteCss;
      environment.etc."xdg/waybar/sway.jsonc".text = builtins.toJSON (
        mkWaybarConfig "sway/workspaces" [ "sway/mode" ]
      );
      environment.etc."xdg/waybar/hyprland.jsonc".text = builtins.toJSON (
        mkWaybarConfig "hyprland/workspaces" [ "hyprland/submap" ]
      );

      environment.etc."xdg/mako/config".text = ''
        background-color=${colors.bg}
        border-color=${colors.focusBorder}
        text-color=${colors.text}
        progress-color=${colors.focus}
        border-size=1
        border-radius=0
        margin=10
        padding=10
        default-timeout=5000
        anchor=top-right
        font=URWGothic 11
      '';

      environment.etc."sway/config".text = swayConfig;
      environment.etc."xdg/hypr/hyprland.conf".text = hyprConfig;
    };
}
