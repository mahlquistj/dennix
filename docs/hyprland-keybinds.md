# Hyprland Keybinds

## Spawners

| Keybind             | Action                   |
| ------------------- | ------------------------ |
| `SUPER + Return`    | Open terminal (Rio)      |
| `SUPER + Space`     | Open app launcher (Rofi) |
| `SUPER + Escape`    | Lock screen              |
| `SUPER + Shift + E` | Exit Hyprland            |

## Workspaces

| Keybind                     | Action                     |
| --------------------------- | -------------------------- |
| `SUPER + 1-9`               | Switch to workspace N      |
| `SUPER + Shift + 1-9`       | Move window to workspace N |
| `SUPER + Alt + <direction>` | Move workspace to monitor  |

## Movement Keys

All movement commands support both **arrow keys** and **HJKL** (vim-style):

- Arrow keys: `left`, `right`, `up`, `down`
- Vim keys: `H` (left), `L` (right), `K` (up), `J` (down)

### Focus

| Keybind               | Action               |
| --------------------- | -------------------- |
| `SUPER + <direction>` | Move focus to window |

### Window Movement

| Keybind                       | Action      |
| ----------------------------- | ----------- |
| `SUPER + Shift + <direction>` | Move window |

### Resizing

| Keybind                      | Action               |
| ---------------------------- | -------------------- |
| `SUPER + Ctrl + <direction>` | Resize active window |

## Window Control

| Keybind     | Action              |
| ----------- | ------------------- |
| `SUPER + V` | Toggle floating     |
| `SUPER + J` | Toggle split        |
| `SUPER + F` | Fullscreen          |
| `SUPER + Q` | Close active window |

## Screenshots

| Keybind                 | Action                   |
| ----------------------- | ------------------------ |
| `SUPER + Print`         | Screenshot active window |
| `SUPER + Shift + Print` | Screenshot region        |
| `Print`                 | Screenshot entire output |

## Screen Recording

| Keybind             | Action                 |
| ------------------- | ---------------------- |
| `SUPER + R`         | Start area recording   |
| `SUPER + Shift + R` | Start screen recording |
| `SUPER + S`         | Stop recording         |

## Audio & Media

> Note: Requires `audio-keybinds` module in home configuration.

### Hardware Controls

| Keybind                | Action                 |
| ---------------------- | ---------------------- |
| `XF86AudioMute`        | Toggle mute            |
| `XF86AudioMicMute`     | Toggle microphone mute |
| `XF86AudioRaiseVolume` | Volume up              |
| `XF86AudioLowerVolume` | Volume down            |

### Media Player

| Keybind                      | Action             |
| ---------------------------- | ------------------ |
| `XF86AudioPlay`              | Play/Pause         |
| `XF86AudioNext`              | Next track         |
| `XF86AudioPrev`              | Previous track     |
| `SUPER + Ctrl + RaiseVolume` | Player volume up   |
| `SUPER + Ctrl + LowerVolume` | Player volume down |

## Display

> Note: Requires `brightness-keybinds` module in home configuration.

| Keybind                 | Action          |
| ----------------------- | --------------- |
| `XF86MonBrightnessUp`   | Brightness up   |
| `XF86MonBrightnessDown` | Brightness down |
