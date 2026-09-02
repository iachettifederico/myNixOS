from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen
from libqtile.lazy import lazy

mod = "mod4"
terminal = "ghostty"
launcher = "rofi -show run"
editor = "emacsclient -c -a emacs"
browser = "firefox"
browser_dev = "firefox-devedition"


def show_workspace(qtile, group_name):
    """Focus an occupied visible workspace; otherwise show it on this screen."""
    group = qtile.groups_map[group_name]

    if group.windows and group.screen is not None:
        qtile.focus_screen(group.screen.index, warp=True)
        return

    group.toscreen()


def move_workspace_to_adjacent_screen(qtile, step):
    """Move the current workspace to the next physical screen and follow it."""
    if len(qtile.screens) < 2:
        return

    ordered_screens = sorted(qtile.screens, key=lambda screen: (screen.x, screen.y))
    current_position = ordered_screens.index(qtile.current_screen)
    target_screen = ordered_screens[(current_position + step) % len(ordered_screens)]

    qtile.current_group.toscreen(target_screen.index)
    qtile.focus_screen(target_screen.index, warp=True)


keys = [
    # Applications
    Key([mod], "Return", lazy.spawn(terminal), desc="Open a terminal"),
    Key([mod], "d", lazy.spawn(launcher), desc="Open the application launcher"),
    Key([mod], "e", lazy.spawn(editor), desc="Open Emacs"),
    Key([mod], "c", lazy.spawn(browser), desc="Open Firefox"),
    Key([mod, "shift"], "c", lazy.spawn(browser_dev), desc="Open Firefox Developer Edition"),
    # Focus and move windows with the same arrow-key model used by i3.
    Key([mod], "Left", lazy.layout.left(), desc="Focus left"),
    Key([mod], "Down", lazy.layout.down(), desc="Focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Focus up"),
    Key([mod], "Right", lazy.layout.right(), desc="Focus right"),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window left"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window right"),
    # Window and layout controls
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Close the focused window"),
    Key([mod], "k", lazy.window.kill(), desc="Close the focused window"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod, "shift"], "space", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "space", lazy.next_layout(), desc="Select the next layout"),
    Key([mod, "control"], "Right", lazy.screen.next_group(), desc="Select the next workspace"),
    Key([mod, "control"], "Left", lazy.screen.prev_group(), desc="Select the previous workspace"),
    Key(
        [mod],
        "bracketleft",
        lazy.function(move_workspace_to_adjacent_screen, -1),
        desc="Move the current workspace to the left screen",
    ),
    Key(
        [mod],
        "bracketright",
        lazy.function(move_workspace_to_adjacent_screen, 1),
        desc="Move the current workspace to the right screen",
    ),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the Qtile config"),
    Key([mod, "shift"], "Escape", lazy.shutdown(), desc="Exit Qtile"),
]

workspace_names = [str(number) for number in range(1, 11)]
workspace_keys = [str(number) for number in range(1, 10)] + ["0"]
groups = [Group(name) for name in workspace_names]

for group, key in zip(groups, workspace_keys):
    keys.extend(
        [
            Key([mod], key, lazy.function(show_workspace, group.name), desc=f"Show workspace {group.name}"),
            Key(
                [mod, "shift"],
                key,
                lazy.window.togroup(group.name, switch_group=True),
                desc=f"Move the focused window to workspace {group.name}",
            ),
        ]
    )

# Keep this palette intentionally small so a later theme can replace it cleanly.
colors = {
    "background": "#20242b",
    "panel": "#2b3038",
    "focused": "#7aa2c7",
    "inactive": "#5b6470",
    "text": "#f0f0f0",
}

layouts = [
    layout.Columns(
        border_focus=colors["focused"],
        border_normal=colors["inactive"],
        border_width=2,
        margin=4,
    ),
    layout.Max(),
]

widget_defaults = {
    "font": "sans",
    "fontsize": 12,
    "padding": 4,
}
extension_defaults = widget_defaults.copy()

def make_screen():
    return Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(highlight_method="block"),
                widget.WindowName(),
                widget.Clock(format="%a %d %b  %H:%M"),
            ],
            26,
            background=colors["panel"],
            foreground=colors["text"],
        )
    )


def generate_screens(outputs):
    """Give each detected output its own Qtile screen and widget instances."""
    return [make_screen() for _ in outputs]

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

floating_layout = layout.Floating(
    border_focus=colors["focused"],
    border_normal=colors["inactive"],
    border_width=2,
)

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
