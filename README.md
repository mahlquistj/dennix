# Dennix NixOS Flake

A NixOS flake configured for Hyprland on the `lene` system, featuring Catppuccin theming and a modular setup.

## Structure

```
.
├── flake.nix              # Main flake entry point
├── flake.lock             # Locked dependencies
├── modules/               # All configuration modules
│   ├── parts.nix          # flake-parts configuration (home-manager import)
│   ├── users/
│   │   └── jdenn.nix      # Home manager config for user jdenn
│   ├── hosts/
│   │   └── lene/          # Host 'lene' configuration
│   │       ├── configuration.nix    # Main NixOS config (imports all modules)
│   │       └── hardware-configuration.nix  # Auto-generated hardware config
│   └── features/          # Reusable feature modules
│       ├── desktop/
│       │   └── hyprland.nix    # Hyprland + hypridle + hyprlock
│       ├── flake-modules/
│       │   └── home-manager.nix   # Home manager flake module
│       ├── fonts/
│       │   └── source-code-pro.nix   # JetBrains Nerd Font
│       ├── programs/
│       │   ├── chromium.nix     # Chromium browser
│       │   ├── git.nix          # Git configuration
│       │   └── rio.nix          # Rio terminal
│       ├── services/
│       │   ├── gddm.nix         # GDM display manager
│       │   └── vicinae.nix      # Vicinae application launcher
│       └── system/
│           ├── audio.nix        # PipeWire/PulseAudio + keybinds
│           ├── brightness.nix   # Backlight control + keybinds
│           └── screenshot.nix   # Screenshot tool + keybinds
```

## Modules

### Users
- **jdenn**: Home manager configuration importing all features, Catppuccin theming, and user-specific Hyprland settings.

### Hosts
- **lene**: Main system configuration importing Hyprland, GDM, audio, fonts, and the user config.

### Features

#### Desktop
- **hyprland**: Complete Hyprland setup including:
  - Hyprland window manager with Catppuccin theming
  - hypridle (idle detection: dim→lock→dpms→suspend)
  - hyprlock (Catppuccin-themed lockscreen with blur screenshot background)

#### Flake Modules
- **home-manager**: Home manager integration for flake-parts

#### Fonts
- **source-code-pro**: JetBrains Mono Nerd Font (Sauce Code Pro)

#### Programs
- **chromium**: Chromium browser configuration
- **git**: Git configuration with default user and commit signing
- **rio**: Rio terminal emulator configuration

#### Services
- **gddm**: GNOME Display Manager (GDM) for the lockscreen
- **vicinae**: Application launcher daemon

#### System
- **audio**: PipeWire audio setup with volume keybinds
- **brightness**: Backlight control with brightness keybinds
- **screenshot**: Screenshot tool (grim + slurp) with keybinds

## Inputs

| Input | Source | Purpose |
|-------|--------|---------|
| `nixpkgs` | `NixOS/nixpkgs/nixos-unstable` | Main package repository |
| `nixpkgs-stable` | `NixOS/nixpkgs/nixos-25.11` | Stable channel for compatibility |
| `flake-parts` | `hercules-ci/flake-parts` | Flake module system |
| `import-tree` | `vic/import-tree` | Auto-import all .nix files from modules/ |
| `home-manager` | `nix-community/home-manager` | User configuration management |
| `catppuccin` | `catppuccin/nix` | Catppuccin theme integration |
| `vicinae` | `vicinaehq/vicinae` | Application launcher |
| `wrapper-modules` | `BirdeeHub/nix-wrapper-modules` | Nix wrapper utilities |

## Usage

```bash
# Build the system
sudo nixos-rebuild switch --flake .#lene

# Build home manager only
home-manager switch --flake .#jdenn
```

## Key Features

- **Hyprland Wayland compositor** with XWayland support
- **Catppuccin Mocha theme** with peach accent
- **Automatic system cleanup** (10-day-old generations)
- **Vim-style keybindings** for window management
- **Idle management** (dim → lock → suspend workflow)
- **Modular architecture** for easy feature additions