{
  self,
  inputs,
  ...
}: {
  # Standalone home manager config - Imports the configuration below it.
  flake.homeConfigurations.jdenn = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      self.homeModules.jdenn
      {
        home.username = "jdenn";
        home.homeDirectory = "/home/jdenn";
      }
    ];
  };

  flake.homeModules.jdenn = {pkgs, ...}: {
    # Imports henter selve konfigurationsfilerne og modulerne ind, som bestemmer, hvordan dit system skal opføre sig og sættes op.
    imports = with self.homeModules; [
      # Nix extensions
      inputs.catppuccin.homeModules.catppuccin

      # Desktop
      hyprland
      hypridle
      hyprlock
      ## Desktop keybind additions
      audio-keybinds
      brightness-keybinds
      screen-record-wayland

      # Launcher
      vicinae

      # Bar
      hyprland-waybar

      # Configured packages/apps
      chromium
      git
      rio

    ];

    # Packages er de faktiske programmer og værktøjer (som CLI-værktøjer eller webbrowsere), du ønsker installeret, så du kan køre dem på computeren.
    home.packages = with pkgs; [
      # Add one-shot packages that don't need config here
      curl
      vscode # Vscode with no config managed by nix
      discord

      # Other fonts we may want for compatability
      twemoji-color-font # Emoji
      google-fonts # Big font collection

      nemo
      # Coding Agents
      pi-coding-agent
    ];

    services = {
      # Automount USB's
      udiskie.enable = true;
    };

    # Theme config
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "peach";
    };

    # Fonts
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        sansSerif = ["Product Sans"];
        emoji = ["Twemoji"];
      };
    };

    # User-specific hyprland configuration
    wayland.windowManager.hyprland.settings = {
      # Keyboard input
      input = {
        kb_layout = "dk";
      };
      # Border colors
      general = {
        # `$peach` and `$base` come from Catppuccin.
        "col.active_border" = "$peach";
        "col.inactive_border" = "$base";
      };
      # Apps
      "$terminal" = "rio";
      "$launcher" = "vicinae toggle";
      "$lock" = "hyprlock";
    };

    xdg.enable = true;

    home.stateVersion = "25.11";
  };
}
