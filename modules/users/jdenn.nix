{
  self,
  inputs,
  ...
}: {
  # Standalone home manager config - Imports the configuration below it.
  flake.homeConfigurations.jdenn = inputs.home-manger.lib.homeManagerConfiguration {
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
    imports = with self.homeModules; [
      # Nix extensions
      inputs.catppuccin.homeModules.catppuccin

      # Desktop
      hyprland
      hypridle
      hyprlock

      # Apps
      chromium
    ];

    home.packages = with pkgs; [
    ];

    # Theme config
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "peach";
    };

    # User-specific hyprland configuration
    wayland.windowManager.hyprland.settings = {
      # Border colors
      general = {
        # `$peach` and `$base` come from Catppuccin.
        "col.active_border" = "$peach";
        "col.inactive_border" = "$base";
      };
      # Apps
      "$terminal" = "rio";
      "$menu" = "";
      "$lock" = "hyprlock";
    };

    services = {
      # Automount USB's
      udiskie.enable = true;
    };

    xdg.enable = true;

    home.stateVersion = "25.11";
  };
}
