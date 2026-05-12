{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.hyprland = {pkgs, ...}: {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = ["gtk"];
        };
        Hyprland = {
          default = ["hyprland" "gtk"];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };

  flake.homeModules.hyprland = {pkgs, ...}: {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            # After 5 minutes, dim screen
            timeout = 300;
            on-timeout = "brightnessctl -s set 10";
            on-resume = "brightnessctl -r";
          }
          {
            # After 10 minutes, lock session
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            # After 10 minutes 30 seconds, tell screens to turn off
            timeout = 630;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }
          {
            # After 30 minutes, suspend system
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          no_fade_in = false;
          no_fade_out = false;
          hide_cursor = false;
          grace = 0;
          ignore_empty_input = true;
          disable_loading_bar = true;
        };

        background = {
          path = "screenshot";
          blur_passes = 2;
          contrast = 1;
          brightness = 0.5;
          vibrancy = 0.2;
          vibrancy_darkness = 0.2;
        };
      };
    };

    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      package = null;

      plugins = [];

      settings = {
      };
    };
  };
}
