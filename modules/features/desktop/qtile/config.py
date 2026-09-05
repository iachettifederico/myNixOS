from __future__ import annotations

import re
import shutil
import subprocess
from pathlib import Path

from libqtile import bar, hook, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen, ScratchPad
from libqtile.lazy import lazy

import traverse


MOD = "mod4"
TERM = "ghostty"

RUNNER = ["rofi", "-show", "run"]
RUNNER_PRIV = ["sudo", "rofi", "-show", "run"]
RUNNER_WINDOWS = ["rofi", "-show", "window"]
EDITOR = ["emacsclient", "-c", "-a", "emacs"]
EDITOR_DEBUG = ["emacs", "--debug-init", str(Path.home() / ".emacs.d" / "Readme.org")]
BROWSER = ["firefox"]
BROWSER_DEV = ["firefox-devedition"]
BROWSER_RAZOR = ["firefox", "--no-remote", "-P", "razor-profile"]
LOCK_SCREEN = [str(Path.home() / "bin" / "lock-screen")]
BLURLOCK = ["blurlock"]
TRACKER = [
    str(Path.home() / "code" / "orlando-market-notification" / "orlando-tracker"),
    "ORL-2026-940004",
    "ORL-2026-130166",
]
NOTIFICATION_HISTORY_SCRIPT = Path.home() / ".config" / "i3" / "notification-history.sh"

BG = "#0A1420"
BG_ALT = "#102033"
SURFACE = "#17324D"
FOCUS = "#2E5F8A"
ACCENT = "#4EA5D9"
FOCUS_BORDER = "#1C3F5E"
NEXT_HINT = "#3A78A8"
TEXT = "#D8E9F7"
MUTED = "#89A8C2"
URGENT = "#B23A48"
PAPER = "#E7DDC8"

BAR_FONT = "DejaVu Sans Mono"
TITLE_FONT = "Comic Neue"
BAR_SIZE = 26

SCRATCHPAD_NAME = "scratchpad"
WORKSPACE_NUMBERS = [str(number) for number in range(1, 11)]
DEDICATED_WORKSPACES = [
    ("💬", "💬", "max"),
    ("🐙", "🐙", None),
    ("📞", "📞", None),
    ("🎬", "🎬", None),
    ("📥", "📥", None),
]
NAV_WORKSPACES = [*WORKSPACE_NUMBERS, *(name for name, _label, _layout in DEDICATED_WORKSPACES)]

CHAT_MATCHES = [
    Match(wm_class=re.compile(r"(?i)^TelegramDesktop$")),
    Match(wm_class=re.compile(r"(?i)^Slack$")),
    Match(wm_class=re.compile(r"(?i)^Keybase$")),
    Match(wm_class=re.compile(r"(?i)^discord$")),
    Match(wm_class=re.compile(r"(?i)^Whatsapp-for-linux$")),
    Match(wm_class=re.compile(r"(?i)^Signal$")),
    Match(wm_class=re.compile(r"(?i)^Ferdium$")),
]

FLOAT_RULES = [
    *layout.Floating.default_float_rules,
    Match(wm_class=re.compile(r"(?i)^System-config-printer\.py$")),
    Match(wm_class=re.compile(r"(?i)^1Password$")),
    Match(wm_class=re.compile(r"(?i)^Cheese$")),
    Match(wm_class=re.compile(r"(?i)^Clipgrab$")),
    Match(wm_class=re.compile(r"(?i)^Clockify$")),
    Match(wm_class=re.compile(r"(?i)^GParted$")),
    Match(wm_class=re.compile(r"(?i)^Galculator$")),
    Match(wm_class=re.compile(r"(?i)^Gnome-calculator$")),
    Match(wm_class=re.compile(r"(?i)^Lightdm-settings$")),
    Match(wm_class=re.compile(r"(?i)^Lxappearance$")),
    Match(wm_class=re.compile(r"(?i)^Manjaro Settings Manager$")),
    Match(wm_class=re.compile(r"(?i)^Manjaro-hello$")),
    Match(wm_class=re.compile(r"(?i)^Nitrogen$")),
    Match(wm_class=re.compile(r"(?i)^NoiseTorch$")),
    Match(wm_class=re.compile(r"(?i)^Pamac-manager$")),
    Match(wm_class=re.compile(r"(?i)^pavucontrol$")),
    Match(wm_class=re.compile(r"(?i)^QjackCtl$")),
    Match(wm_class=re.compile(r"(?i)^Qtconfig-qt4$")),
    Match(wm_class=re.compile(r"(?i)^Shutter$")),
    Match(wm_class=re.compile(r"(?i)^Simple-scan$")),
    Match(wm_class=re.compile(r"(?i)^Skype$")),
    Match(wm_class=re.compile(r"(?i)^Surf$")),
    Match(wm_class=re.compile(r"(?i)^Timeset-gui$")),
    Match(wm_class=re.compile(r"(?i)^Tk$")),
    Match(wm_class=re.compile(r"(?i)^Tuple$")),
    Match(wm_class=re.compile(r"(?i)^Xfburn$")),
    Match(wm_class=re.compile(r"(?i)^calamares$")),
    Match(wm_class=re.compile(r"(?i)^fpakman$")),
    Match(wm_class=re.compile(r"(?i)^gnome-calculator$")),
    Match(wm_class=re.compile(r"(?i)^octopi$")),
    Match(wm_class=re.compile(r"(?i)^qt5ct$")),
    Match(wm_class=re.compile(r"(?i)^zoom$")),
    Match(title=re.compile(r"^File Transfer.*$")),
    Match(title=re.compile(r"^MuseScore: Play Panel$")),
    Match(title=re.compile(r"^alsamixer$")),
    Match(title=re.compile(r"^i3_help$")),
    Match(title=re.compile(r"^floating$")),
]

NO_FLOAT_RULES = [Match(wm_class=re.compile(r"(?i)^VirtualBox Machine$"))]
STICKY_RULES = [
    Match(wm_class=re.compile(r"(?i)^1Password$")),
    Match(wm_class=re.compile(r"(?i)^gnome-calculator$")),
    Match(wm_class=re.compile(r"(?i)^Lxappearance$")),
    Match(wm_class=re.compile(r"(?i)^Nitrogen$")),
    Match(wm_class=re.compile(r"(?i)^Qtconfig-qt4$")),
    Match(wm_class=re.compile(r"(?i)^Shutter$")),
    Match(wm_class=re.compile(r"(?i)^qt5ct$")),
    Match(wm_class=re.compile(r"(?i)^pavucontrol$")),
    Match(title=re.compile(r"^i3_help$")),
]

OBLOGOUT_MATCH = Match(wm_class=re.compile(r"(?i)^Oblogout$"))
PAVUCONTROL_MATCH = Match(wm_class=re.compile(r"(?i)^pavucontrol$"))


def _is_available(command: list[str]) -> bool:
    return shutil.which(command[0]) is not None or Path(command[0]).exists()


def _spawn_local(command: list[str]) -> None:
    if _is_available(command):
        subprocess.Popen(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)


def spawn_if_available(qtile, command: list[str], group: str | None = None) -> None:
    if _is_available(command):
        qtile.spawn(command, group=group)


def spawn_key(command: list[str], group: str | None = None):
    return lazy.function(lambda qtile: spawn_if_available(qtile, command, group=group))


def qfunc(func, *args):
    return lazy.function(lambda qtile: func(qtile, *args))


def make_key(modifiers: list[str], key: str | int, command, desc: str, **meta) -> Key:
    binding = Key(modifiers, key, command, desc=desc)
    for attr, value in meta.items():
        setattr(binding, attr, value)
    return binding


def show_group(qtile, group_name: str, screen_index: int | None = None) -> None:
    group = qtile.groups_map[group_name]
    if group.screen is not None:
        qtile.focus_screen(group.screen.index, warp=True)
        return

    target_screen = qtile.screens[screen_index if screen_index is not None else qtile.current_screen.index]
    target_screen.set_group(group, warp=False)
    qtile.focus_screen(target_screen.index, warp=True)


def move_window_to_group(qtile, group_name: str) -> None:
    if qtile.current_window is None:
        return

    qtile.current_window.togroup(group_name)
    show_group(qtile, group_name, screen_index=qtile.current_screen.index)


def next_workspace(qtile, step: int) -> None:
    if qtile.current_group is None:
        return

    current = qtile.current_group.name
    if current not in NAV_WORKSPACES:
        current = NAV_WORKSPACES[0]
    target = NAV_WORKSPACES[(NAV_WORKSPACES.index(current) + step) % len(NAV_WORKSPACES)]
    show_group(qtile, target)


def move_workspace_to_screen(qtile, direction: str) -> None:
    target_screen = traverse.adjacent_screen(qtile, direction)
    if target_screen is None or qtile.current_group is None:
        return

    current_screen = qtile.current_screen
    current_group = qtile.current_group
    if target_screen.group is current_group:
        return

    fallback = next(
        (
            group
            for group in qtile.groups
            if group.name in NAV_WORKSPACES and group.screen is None and group is not current_group
        ),
        None,
    )

    if fallback is not None:
        current_screen.set_group(fallback, warp=False)
        target_screen.set_group(current_group, warp=False)
        qtile.focus_screen(target_screen.index, warp=True)
        return

    current_group.toscreen(target_screen.index)
    qtile.focus_screen(target_screen.index, warp=True)


def move_window_to_screen(qtile, direction: str) -> None:
    target = traverse.best_target(qtile, direction)
    if target is None or qtile.current_window is None:
        return

    window = qtile.current_window
    if target.screen_index != qtile.current_screen.index:
        destination_group = qtile.screens[target.screen_index].group
        window.togroup(destination_group.name)
        qtile.focus_screen(target.screen_index, warp=True)
        destination_group.focus(window, True)
        window.bring_to_front()
        return

    if window.floating:
        step = 32
        deltas = {"left": (-step, 0), "right": (step, 0), "up": (0, -step), "down": (0, step)}
        window.move_floating(*deltas[direction])
        return

    if isinstance(qtile.current_layout, layout.Plasma):
        {
            "left": qtile.current_layout.move_left,
            "right": qtile.current_layout.move_right,
            "up": qtile.current_layout.move_up,
            "down": qtile.current_layout.move_down,
        }[direction]()


def toggle_keep_above(qtile) -> None:
    # Qtile keep_above is only a partial sticky approximation; it does not follow i3
    # across workspaces the way sticky windows do.
    window = qtile.current_window
    if window is None:
        return

    window.keep_above()


def focus_parent_feedback(qtile) -> None:
    spawn_if_available(qtile, ["notify-send", "Plasma has no focusable parent node"])


def focus_mode_toggle(qtile) -> None:
    group = qtile.current_group
    window = qtile.current_window
    if group is None or window is None:
        return

    if window.floating:
        target = group.layout.focus_first()
    else:
        target = group.floating_layout.focus_first(group=group)

    if target is not None:
        group.focus(target, True)


def toggle_bars(qtile) -> None:
    qtile.hide_show_bar(position="bottom", screen="all")


def set_plasma_orientation(qtile, horizontal: bool) -> None:
    current_layout = qtile.current_layout
    if not isinstance(current_layout, layout.Plasma):
        return
    if horizontal:
        current_layout.mode_horizontal()
    else:
        current_layout.mode_vertical()


def toggle_plasma_orientation(qtile) -> None:
    current_layout = qtile.current_layout
    if not isinstance(current_layout, layout.Plasma):
        return
    set_plasma_orientation(qtile, not current_layout.horizontal)


def set_max_layout(qtile) -> None:
    qtile.current_group.setlayout("max")


def toggle_layout(qtile) -> None:
    qtile.current_group.use_next_layout()


def toggle_scratchpad(qtile) -> None:
    scratchpad = qtile.groups_map[SCRATCHPAD_NAME]
    if scratchpad.screen is not None and scratchpad.screen is not qtile.current_screen:
        qtile.focus_screen(scratchpad.screen.index, warp=True)
        return

    qtile.current_screen.toggle_group(SCRATCHPAD_NAME, warp=False)
    qtile.focus_screen(qtile.current_screen.index, warp=True)


def stash_to_scratchpad(qtile) -> None:
    window = qtile.current_window
    if window is None or window.group is None or window.group.name == SCRATCHPAD_NAME:
        return

    window.enable_floating()
    window.togroup(SCRATCHPAD_NAME)


def _group_bindings(group_name: str) -> list[Key]:
    select_specs, move_specs = GROUP_ALIAS_SPECS[group_name]
    bindings: list[Key] = []
    for modifiers, key in select_specs:
        bindings.append(
            make_key(
                [MOD, *modifiers],
                key,
                qfunc(show_group, group_name),
                desc=f"Show workspace {group_name}",
                binding_kind="workspace_alias",
                action="show_group",
                group_name=group_name,
            )
        )
    for modifiers, key in move_specs:
        bindings.append(
            make_key(
                [MOD, *modifiers],
                key,
                qfunc(move_window_to_group, group_name),
                desc=f"Move the focused window to workspace {group_name}",
                binding_kind="workspace_alias",
                action="move_window_to_group",
                group_name=group_name,
            )
        )
    return bindings


class NotificationHistory(widget.GenPollText):
    def __init__(self, **config):
        super().__init__(func=self._poll_history, markup=True, **config)
        self.add_callbacks(
            {
                "Button1": self.open_history,
                "Button2": self.pop_history,
                "Button3": self.clear_history,
                "Button8": self.open_history,
                "Button9": self.pop_history,
                "Button10": self.clear_history,
                "Button11": self.open_history,
                "Button12": self.clear_history,
            }
        )

    def _poll_history(self) -> str:
        try:
            count = subprocess.check_output(["dunstctl", "count", "history"], text=True).strip()
        except Exception:
            count = "?"

        if count == "?":
            self.background = BG_ALT
            self.foreground = MUTED
            return f'<span foreground="{MUTED}">NOTIF: ?</span>'

        if count == "0":
            self.background = BG_ALT
            self.foreground = MUTED
            return f'<span foreground="{MUTED}">NOTIF: 0</span>'

        self.background = ACCENT
        self.foreground = BG
        return f'<span foreground="{BG}">NOTIF: {count}</span>'

    def open_history(self) -> None:
        if NOTIFICATION_HISTORY_SCRIPT.exists():
            _spawn_local([str(NOTIFICATION_HISTORY_SCRIPT)])

    def pop_history(self) -> None:
        _spawn_local(["dunstctl", "history-pop"])

    def clear_history(self) -> None:
        _spawn_local(["dunstctl", "history-clear"])


class GlobalGroupBox(widget.GroupBox):
    def __init__(self, **config):
        super().__init__(**config)
        self.disable_drag = True

    def go_to_group(self, group):
        if group is None:
            return
        show_group(self.qtile, group.name, screen_index=self.bar.screen.index)

    def next_group(self):
        next_workspace(self.qtile, 1)

    def prev_group(self):
        next_workspace(self.qtile, -1)


def _gpu_text() -> str:
    try:
        out = subprocess.check_output(
            ["nvidia-smi", "--query-gpu=utilization.gpu", "--format=csv,noheader,nounits"],
            text=True,
            stderr=subprocess.DEVNULL,
        ).strip()
    except Exception:
        return "GPU: n/a"

    value = out.splitlines()[0].strip() if out else ""
    return f"GPU: {value}%" if value else "GPU: n/a"


def _first_ipv4_text() -> str:
    try:
        out = subprocess.check_output(
            ["ip", "-4", "-o", "addr", "show", "up", "scope", "global"],
            text=True,
            stderr=subprocess.DEVNULL,
        )
    except Exception:
        return "E: down"

    for line in out.splitlines():
        fields = line.split()
        if "inet" not in fields:
            continue
        try:
            ip = fields[fields.index("inet") + 1].split("/")[0]
        except Exception:
            continue
        return f"E: {ip}"

    return "E: down"


def _make_widgets(include_systray: bool):
    widgets = [
        GlobalGroupBox(
            font=BAR_FONT,
            fontsize=10,
            borderwidth=2,
            border=BG,
            active=TEXT,
            inactive=MUTED,
            highlight_method="block",
            block_highlight_text_color=TEXT,
            rounded=False,
            this_current_screen_border=FOCUS,
            this_screen_border=SURFACE,
            other_current_screen_border=SURFACE,
            other_screen_border=BG_ALT,
            urgent_alert_method="block",
            urgent_border=URGENT,
            urgent_text=PAPER,
            hide_unused=False,
            use_mouse_wheel=True,
            spacing=0,
            padding_x=6,
            padding_y=4,
            margin_x=0,
            margin_y=0,
        ),
        widget.Chord(
            font=BAR_FONT,
            fontsize=10,
            background=BG,
            foreground=BG,
            chords_colors={
                "system": (ACCENT, BG),
                "resize": (FOCUS, BG),
                "passthrough": (NEXT_HINT, BG),
            },
            name_transform=lambda name: f"[{name}]",
            padding=6,
        ),
        widget.CurrentLayout(
            font=BAR_FONT,
            fontsize=10,
            foreground=TEXT,
            background=BG,
            padding=6,
        ),
        widget.Plasma(
            font=BAR_FONT,
            fontsize=10,
            foreground=NEXT_HINT,
            background=BG,
            padding=6,
        ),
        widget.WindowName(
            font=TITLE_FONT,
            fontsize=11,
            foreground=PAPER,
            background=BG_ALT,
            padding=6,
        ),
        widget.Spacer(background=BG),
        widget.GenPollText(
            func=_gpu_text,
            update_interval=5,
            font=BAR_FONT,
            fontsize=10,
            foreground=NEXT_HINT,
            background=BG,
            padding=6,
        ),
        NotificationHistory(font=BAR_FONT, fontsize=10, background=BG_ALT, foreground=MUTED, padding=6),
        widget.GenPollText(
            func=_first_ipv4_text,
            update_interval=10,
            font=BAR_FONT,
            fontsize=10,
            foreground=MUTED,
            background=BG,
            padding=6,
        ),
        widget.Memory(
            format="Mem: {MemUsed:.0f}{mm}",
            measure_mem="M",
            update_interval=5,
            font=BAR_FONT,
            fontsize=10,
            foreground=TEXT,
            background=BG,
            padding=6,
        ),
        widget.Clock(
            format="%Y-%m-%d %H:%M",
            font=BAR_FONT,
            fontsize=10,
            foreground=TEXT,
            background=BG,
            padding=6,
        ),
    ]
    if include_systray:
        widgets.append(widget.Systray(background=BG, padding=4))
    return widgets


def _make_screen(include_systray: bool) -> Screen:
    return Screen(bottom=bar.Bar(_make_widgets(include_systray), BAR_SIZE, background=BG, margin=0))


def generate_screens(outputs):
    return [_make_screen(getattr(output, "port", None) == "DP-0") for output in outputs]


STARTUP_ALWAYS = [
    ["xset", "s", "off"],
    [str(Path.home() / "bin" / "us_keyboard")],
    ["ff-theme-util"],
    ["fix_xcursor"],
    ["feh", "--bg-fill", str(Path.home() / "Pictures" / "miles.png")],
]

STARTUP_ONCE = [
    (["/run/current-system/sw/libexec/polkit-gnome-authentication-agent-1"], None),
    (["systemctl", "--user", "start", "dunst.service"], None),
    (["pasystray"], None),
    (["nm-applet"], None),
    (["xfce4-power-manager"], None),
    (["pamac-tray"], None),
    (["clipit"], None),
    (["xautolock", "-time", "1800", "-locker", "blurlock"], None),
    (["tilda"], None),
    (["volumeicon"], None),
    (["flameshot"], None),
    (["morgen"], None),
    (BROWSER, "3"),
    (["pavucontrol"], "1"),
    (["1password"], "1"),
    (EDITOR, "1"),
    (["Telegram"], "💬"),
    (["discord"], "💬"),
    (["ferdium"], "💬"),
    (["slack"], "💬"),
]


def _startup_once(qtile) -> None:
    for command, group_name in STARTUP_ONCE:
        spawn_if_available(qtile, command, group=group_name)
    show_group(qtile, "1")


@hook.subscribe.startup_once
def _on_startup_once() -> None:
    from libqtile import qtile

    _startup_once(qtile)


@hook.subscribe.startup
def _on_startup() -> None:
    from libqtile import qtile

    for command in STARTUP_ALWAYS:
        spawn_if_available(qtile, command)


@hook.subscribe.client_managed
def _client_managed(client):
    if any(match.compare(client) for match in NO_FLOAT_RULES):
        client.disable_floating()
        return

    if any(match.compare(client) for match in FLOAT_RULES):
        client.enable_floating()

    if any(match.compare(client) for match in STICKY_RULES):
        client.keep_above(True)

    if OBLOGOUT_MATCH.compare(client):
        client.toggle_fullscreen()

    if PAVUCONTROL_MATCH.compare(client):
        client.keep_above(True)
        client.togroup(SCRATCHPAD_NAME)


def _resize_mode_bindings() -> list[Key]:
    return [
        make_key([], "j", lazy.layout.grow_width(-5), "Shrink width", chord="resize"),
        make_key([], "k", lazy.layout.grow_height(5), "Grow height", chord="resize"),
        make_key([], "l", lazy.layout.grow_height(-5), "Shrink height", chord="resize"),
        make_key([], "semicolon", lazy.layout.grow_width(5), "Grow width", chord="resize"),
        make_key([], "Left", lazy.layout.grow_width(-5), "Shrink width", chord="resize"),
        make_key([], "Down", lazy.layout.grow_height(5), "Grow height", chord="resize"),
        make_key([], "Up", lazy.layout.grow_height(-5), "Shrink height", chord="resize"),
        make_key([], "Right", lazy.layout.grow_width(5), "Grow width", chord="resize"),
        make_key([], "Return", lazy.ungrab_chord(), "Leave the mode", chord="resize"),
    ]


def _system_mode_bindings() -> list[Key]:
    specs = [
        ([], "l", ["i3exit", "lock"], "Lock"),
        ([], "s", ["i3exit", "suspend"], "Suspend"),
        ([], "u", ["i3exit", "switch_user"], "Switch user"),
        ([], "e", ["i3exit", "logout"], "Logout"),
        ([], "h", ["i3exit", "hibernate"], "Hibernate"),
        ([], "r", ["i3exit", "reboot"], "Reboot"),
        (["shift"], "s", ["i3exit", "shutdown"], "Shutdown"),
    ]
    bindings = [
        Key(modifiers, key, spawn_key(command), lazy.ungrab_chord(), desc=desc)
        for modifiers, key, command, desc in specs
    ]
    bindings.append(make_key([], "Return", lazy.ungrab_chord(), "Leave the mode", chord="system"))
    return bindings


def _passthrough_mode_bindings() -> list[Key]:
    return [make_key([MOD], "Escape", lazy.ungrab_chord(), "Leave the mode", chord="passthrough")]


GROUP_ALIAS_SPECS: dict[str, tuple[list[tuple[list[str], str]], list[tuple[list[str], str]]]] = {
    "💬": ([([], "F1"), (["control"], "1")], [(["shift"], "F1"), (["control", "shift"], "1")]),
    "🐙": ([([], "F2"), (["control"], "2")], [(["shift"], "F2"), (["control", "shift"], "2")]),
    "📞": ([([], "F3"), (["control"], "3")], [(["shift"], "F3"), (["control", "shift"], "3")]),
    "🎬": ([([], "F5"), (["control"], "5")], [(["shift"], "F5"), (["control", "shift"], "5")]),
    "📥": ([([], "F12"), (["control"], "0")], [(["shift"], "F12"), (["control", "shift"], "0")]),
}

def _make_numbered_binding(modifiers: list[str], key: str, group_name: str, action: str) -> Key:
    command = qfunc(show_group if action == "show_group" else move_window_to_group, group_name)
    return make_key(
        [MOD, *modifiers],
        key,
        command,
        f"{'Show' if action == 'show_group' else 'Move the focused window to'} workspace {group_name}",
        binding_kind="workspace_number",
        action=action,
        group_name=group_name,
    )


keys = [
    make_key([MOD], "Return", lazy.spawn([TERM]), "Open a terminal"),
    make_key([MOD], "d", lazy.spawn(RUNNER), "Open the application launcher"),
    make_key([MOD, "shift"], "d", lazy.spawn(RUNNER_PRIV), "Open the privileged launcher"),
    make_key(["mod1", "shift"], "Tab", lazy.spawn(RUNNER_WINDOWS), "Open the window launcher"),
    make_key([MOD], "e", lazy.spawn(EDITOR), "Open Emacs"),
    make_key([MOD, "shift"], "e", lazy.spawn(EDITOR_DEBUG), "Open debug Emacs"),
    make_key([MOD], "c", lazy.spawn(BROWSER), "Open Firefox"),
    make_key([MOD, "shift"], "c", lazy.spawn(BROWSER_DEV), "Open Firefox Developer Edition"),
    make_key([MOD, "control"], "j", lazy.spawn(BROWSER_RAZOR), "Open the razor Firefox profile"),
    make_key([MOD], "g", spawn_key([str(Path.home() / "bin" / "file-bookmarks")]), "Open file bookmarks"),
    make_key([MOD], "b", spawn_key([str(Path.home() / "bin" / "web-bookmarks")]), "Open web bookmarks"),
    make_key([MOD, "shift"], "b", spawn_key([str(Path.home() / "bin" / "web-bookmarks-brave")]), "Open Brave bookmarks"),
    make_key([MOD], "F10", spawn_key(TRACKER), "Open the tracker"),
    make_key([MOD, "shift"], "q", lazy.window.kill(), "Close the focused window"),
    make_key([MOD, "control"], "k", spawn_key(["xkill"]), "Kill a window with xkill"),
    make_key([MOD], "f", lazy.window.toggle_fullscreen(), "Toggle fullscreen"),
    make_key([MOD, "shift"], "space", lazy.window.toggle_floating(), "Toggle floating"),
    make_key([MOD], "space", qfunc(focus_mode_toggle), "Switch focus between tiled and floating windows"),
    make_key([MOD, "control"], "Right", qfunc(next_workspace, 1), "Next workspace"),
    make_key([MOD, "control"], "Left", qfunc(next_workspace, -1), "Previous workspace"),
    make_key([MOD], "bracketleft", qfunc(move_workspace_to_screen, "left"), "Move the current workspace to the left output"),
    make_key([MOD], "bracketright", qfunc(move_workspace_to_screen, "right"), "Move the current workspace to the right output"),
    make_key([MOD], "h", qfunc(traverse.focus_direction, "left"), "Focus left"),
    make_key([MOD], "j", qfunc(traverse.focus_direction, "down"), "Focus down"),
    make_key([MOD], "k", qfunc(traverse.focus_direction, "up"), "Focus up"),
    make_key([MOD], "l", qfunc(traverse.focus_direction, "right"), "Focus right"),
    make_key([MOD], "Left", qfunc(traverse.focus_direction, "left"), "Focus left"),
    make_key([MOD], "Down", qfunc(traverse.focus_direction, "down"), "Focus down"),
    make_key([MOD], "Up", qfunc(traverse.focus_direction, "up"), "Focus up"),
    make_key([MOD], "Right", qfunc(traverse.focus_direction, "right"), "Focus right"),
    make_key([MOD, "shift"], "Left", qfunc(move_window_to_screen, "left"), "Move window left"),
    make_key([MOD, "shift"], "Down", qfunc(move_window_to_screen, "down"), "Move window down"),
    make_key([MOD, "shift"], "Up", qfunc(move_window_to_screen, "up"), "Move window up"),
    make_key([MOD, "shift"], "Right", qfunc(move_window_to_screen, "right"), "Move window right"),
    make_key([MOD], "v", qfunc(set_plasma_orientation, False), "Use vertical Plasma splits"),
    make_key([MOD, "control"], "h", qfunc(set_plasma_orientation, True), "Use horizontal Plasma splits"),
    make_key([MOD], "q", qfunc(toggle_plasma_orientation), "Toggle Plasma split orientation"),
    make_key([MOD], "s", qfunc(set_max_layout), "Use the tabbed/stack approximation"),
    make_key([MOD], "t", qfunc(set_max_layout), "Use the tabbed/stack approximation"),
    make_key([MOD], "w", qfunc(toggle_layout), "Toggle Plasma and Max layouts"),
    make_key([MOD], "m", qfunc(toggle_bars), "Toggle bars on all screens"),
    make_key([MOD], "a", qfunc(focus_parent_feedback), "Focus the parent container"),
    make_key([MOD, "shift"], "s", qfunc(toggle_keep_above), "Toggle sticky approximation"),
    make_key([MOD, "shift"], "r", lazy.restart(), "Restart Qtile in place"),
    make_key([MOD, "shift"], "Escape", lazy.shutdown(), "Exit Qtile"),
    make_key([MOD], "slash", spawn_key([str(Path.home() / "bin" / "scratchpad_windows")]), "Open the scratchpad windows helper"),
    make_key([MOD, "shift"], "minus", qfunc(stash_to_scratchpad), "Stash the focused window"),
    make_key([MOD], "minus", qfunc(toggle_scratchpad), "Toggle the scratchpad group"),
    make_key([], 232, spawn_key(["brightnessctl", "set", "10%-"]), "Decrease brightness"),
    make_key([], 233, spawn_key(["brightnessctl", "set", "10%+"]), "Increase brightness"),
    make_key([], "XF86Calculator", spawn_key(["gnome-calculator"]), "Open the calculator"),
    make_key([], "Print", spawn_key(["flameshot", "gui"]), "Take a screenshot"),
    make_key([MOD, "control"], "l", spawn_key(LOCK_SCREEN), "Lock the screen"),
    make_key([MOD, "shift"], "l", spawn_key(BLURLOCK), "Lock the screen"),
]

for number, group_name in zip(["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"], WORKSPACE_NUMBERS):
    keys.append(_make_numbered_binding([], number, group_name, "show_group"))
    keys.append(_make_numbered_binding(["shift"], number, group_name, "move_window_to_group"))

for group_name in NAV_WORKSPACES[10:]:
    keys.extend(_group_bindings(group_name))

resize_mode = KeyChord([MOD], "r", _resize_mode_bindings(), mode=True, name="resize", desc="Resize mode")
system_mode = KeyChord([MOD, "shift"], "F9", _system_mode_bindings(), mode=True, name="system", desc="System mode")
passthrough_mode = KeyChord(
    [MOD, "shift"],
    "p",
    _passthrough_mode_bindings(),
    mode=True,
    name="passthrough",
    desc="Passthrough mode",
    swallow=False,
)

keys.extend([resize_mode, system_mode, passthrough_mode])


def _normalize_modifiers(modifiers: list[str]) -> tuple[str, ...]:
    order = ["mod4", "mod1", "control", "shift", "mod2", "mod3", "mod5", "lock"]
    return tuple(sorted(modifiers, key=lambda mod: order.index(mod) if mod in order else len(order)))


def _assert_binding_uniqueness() -> None:
    seen: set[tuple[tuple[str, ...], str | int]] = set()
    root_pairs: list[tuple[tuple[str, ...], str | int]] = []

    for binding in keys:
        pair = (_normalize_modifiers(binding.modifiers), binding.key)
        if pair in seen:
            raise AssertionError(f"duplicate key binding: {pair}")
        seen.add(pair)
        root_pairs.append(pair)

    if root_pairs.count((("mod4", "shift"), "l")) != 1:
        raise AssertionError("expected exactly one root Mod+Shift+l binding")

    for chord in (resize_mode, system_mode, passthrough_mode):
        inner_seen: set[tuple[tuple[str, ...], str | int]] = set()
        for binding in chord.submappings:
            pair = (_normalize_modifiers(binding.modifiers), binding.key)
            if pair in inner_seen:
                raise AssertionError(f"duplicate key inside chord {chord.name}: {pair}")
            inner_seen.add(pair)


def _assert_workspace_binding_counts() -> None:
    numbered = [binding for binding in keys if getattr(binding, "binding_kind", None) == "workspace_number"]
    aliases = [binding for binding in keys if getattr(binding, "binding_kind", None) == "workspace_alias"]
    if len(numbered) != 20:
        raise AssertionError(f"expected 20 numbered workspace bindings, got {len(numbered)}")
    if len(aliases) != 20:
        raise AssertionError(f"expected 20 dedicated workspace alias bindings, got {len(aliases)}")

    for binding in numbered:
        action = getattr(binding, "action", None)
        if action not in {"show_group", "move_window_to_group"}:
            raise AssertionError(f"unexpected numbered binding action: {action}")

    for binding in aliases:
        action = getattr(binding, "action", None)
        if action not in {"show_group", "move_window_to_group"}:
            raise AssertionError(f"unexpected alias binding action: {action}")


_assert_binding_uniqueness()
_assert_workspace_binding_counts()

mouse = [
    Drag([MOD], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([MOD], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([], "Button2", lazy.window.kill()),
    Click([], "Button8", qfunc(show_group, "📥")),
    Click([], "Button9", spawn_key(["dunstctl", "history-pop"])),
    Click([], "Button10", spawn_key(["dunstctl", "history-clear"])),
    Click([], "Button11", spawn_key([str(NOTIFICATION_HISTORY_SCRIPT)])),
    Click([], "Button12", spawn_key(["dunstctl", "history-clear"])),
    Click([MOD], "Button2", lazy.window.bring_to_front()),
]

# Plasma is the only normal tiling layout; the 3px margin is the closest built-in gap approximation.
layouts = [
    layout.Plasma(
        border_focus=ACCENT,
        border_normal=BG_ALT,
        border_focus_fixed=ACCENT,
        border_normal_fixed=FOCUS,
        border_width=2,
        border_width_single=0,
        margin=3,
        fair=False,
    ),
    layout.Max(border_focus=ACCENT, border_normal=FOCUS_BORDER, border_width=2, margin=3),
]

floating_layout = layout.Floating(
    float_rules=FLOAT_RULES,
    border_focus=ACCENT,
    border_normal=FOCUS_BORDER,
    border_width=2,
    max_border_width=2,
    fullscreen_border_width=0,
)

widget_defaults = {"font": BAR_FONT, "fontsize": 10, "padding": 4, "foreground": TEXT}
extension_defaults = widget_defaults.copy()

groups = [
    *[Group(name, label=str(number)) for number, name in zip(WORKSPACE_NUMBERS, WORKSPACE_NUMBERS)],
    *[Group(name, label=label, layout=layout_name) if layout_name else Group(name, label=label) for name, label, layout_name in DEDICATED_WORKSPACES],
    ScratchPad(SCRATCHPAD_NAME, [], label=""),
]

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "never"
reconfigure_screens = True
auto_minimize = True
