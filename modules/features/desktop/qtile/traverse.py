from __future__ import annotations

from dataclasses import dataclass
from typing import Any

from libqtile.backend.base import Window
from libqtile.config import Screen


@dataclass(frozen=True)
class Rect:
    x: int
    y: int
    width: int
    height: int

    @property
    def left(self) -> int:
        return self.x

    @property
    def top(self) -> int:
        return self.y

    @property
    def right(self) -> int:
        return self.x + self.width

    @property
    def bottom(self) -> int:
        return self.y + self.height

    @property
    def center_x(self) -> float:
        return self.x + self.width / 2

    @property
    def center_y(self) -> float:
        return self.y + self.height / 2


@dataclass(frozen=True)
class OrientedRect:
    main_start: int
    main_end: int
    cross_start: int
    cross_end: int

    @property
    def center_main(self) -> float:
        return (self.main_start + self.main_end) / 2

    @property
    def center_cross(self) -> float:
        return (self.cross_start + self.cross_end) / 2


@dataclass(frozen=True)
class Target:
    obj: Window | Screen
    rect: Rect
    kind: str
    screen_index: int


def rect_from_obj(obj: Any) -> Rect:
    return Rect(int(obj.x), int(obj.y), int(obj.width), int(obj.height))


def _oriented(rect: Rect, direction: str) -> OrientedRect:
    if direction == "right":
        return OrientedRect(rect.left, rect.right, rect.top, rect.bottom)
    if direction == "left":
        return OrientedRect(-rect.right, -rect.left, rect.top, rect.bottom)
    if direction == "down":
        return OrientedRect(rect.top, rect.bottom, rect.left, rect.right)
    if direction == "up":
        return OrientedRect(-rect.bottom, -rect.top, rect.left, rect.right)
    raise ValueError(f"Unsupported direction: {direction}")


def _overlap(a_start: int, a_end: int, b_start: int, b_end: int) -> int:
    return max(0, min(a_end, b_end) - max(a_start, b_start))


def _score(focus: Rect, candidate: Rect, direction: str) -> tuple:
    focus_o = _oriented(focus, direction)
    candidate_o = _oriented(candidate, direction)

    if candidate_o.center_main <= focus_o.center_main:
        return ()

    overlap = _overlap(focus_o.cross_start, focus_o.cross_end, candidate_o.cross_start, candidate_o.cross_end)
    major_distance = max(0, candidate_o.main_start - focus_o.main_end)
    cross_distance = abs(focus_o.center_cross - candidate_o.center_cross)
    overlap_rank = 0 if overlap > 0 else 1
    return (
        overlap_rank,
        -overlap,
        major_distance,
        cross_distance,
        candidate_o.main_start,
        candidate_o.cross_start,
        candidate.x,
        candidate.y,
        candidate.width,
        candidate.height,
    )


def _screen_rect(screen: Screen) -> Rect:
    return rect_from_obj(screen)


def _window_rect(window: Window) -> Rect:
    return rect_from_obj(window)


def _focus_origin(qtile) -> Rect:
    return _window_rect(qtile.current_window) if qtile.current_window else _screen_rect(qtile.current_screen)


def focusable_targets(qtile) -> list[Target]:
    targets: list[Target] = []
    current_window = qtile.current_window
    current_screen = qtile.current_screen

    for screen in qtile.screens:
        windows = [window for window in screen.group.windows if window.is_visible() and window is not current_window]
        fullscreen = [window for window in windows if window.fullscreen]
        if fullscreen:
            for window in fullscreen:
                targets.append(Target(window, _window_rect(window), "window", screen.index))
            continue
        if not windows and screen is not current_screen:
            targets.append(Target(screen, _screen_rect(screen), "screen", screen.index))
            continue
        for window in windows:
            targets.append(Target(window, _window_rect(window), "window", screen.index))

    return targets


def best_target(qtile, direction: str) -> Target | None:
    focus = _focus_origin(qtile)
    scored: list[tuple[tuple, Target]] = []
    for target in focusable_targets(qtile):
        score = _score(focus, target.rect, direction)
        if score:
            scored.append(((score[0], score[1], score[2], score[3], 0 if target.kind == "window" else 1, target.screen_index, getattr(target.obj, "wid", -1), target.rect.x, target.rect.y), target))

    if not scored:
        return None
    scored.sort(key=lambda item: item[0])
    return scored[0][1]


def adjacent_screen(qtile, direction: str) -> Screen | None:
    focus = _screen_rect(qtile.current_screen)
    scored: list[tuple[tuple, Screen]] = []
    for screen in qtile.screens:
        if screen is qtile.current_screen:
            continue
        candidate = _screen_rect(screen)
        score = _score(focus, candidate, direction)
        if score:
            scored.append(((score[0], score[1], score[2], score[3], screen.index, candidate.x, candidate.y), screen))

    if not scored:
        return None
    scored.sort(key=lambda item: item[0])
    return scored[0][1]


def focus_direction(qtile, direction: str):
    target = best_target(qtile, direction)
    if target is None:
        return None

    if target.kind == "screen":
        qtile.focus_screen(target.screen_index, warp=True)
        return target.obj

    screen = target.obj.group.screen
    if screen is not None:
        qtile.focus_screen(screen.index, warp=True)
    target.obj.group.focus(target.obj, True)
    target.obj.bring_to_front()
    return target.obj
