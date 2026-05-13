{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hyprland = {pkgs, ...}: {
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

    homeModules.hyprland = {pkgs, ...}: {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };

          listener = [
            {
              # After 5 minutes, dim screen
              timeout = 300;
              on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
              on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
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
              on-resume = "hyprctl dispatch dpms on && ${pkgs.brightnessctl}/bin/brightnessctl -r";
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

        settings = {
          general = {
            gaps_in = 2;
            gaps_out = 5;
            border_size = 1;
            resize_on_border = false;
          };
          cursor = {
            inactive_timeout = 10;
            hide_on_key_press = true;
          };
          decoration = {
            blur = {
              enabled = true;
              size = 8;
              passes = 2;
              new_optimizations = true;
              ignore_opacity = true;
            };

            rounding = 10;
            inactive_opacity = 0.8;
            dim_inactive = true;
            dim_strength = 0.1;
          };
          input = {
            kb_layout = "dk";
          };
          animations = {
            enabled = "yes";
            bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
            animation = [
              "windows, 1, 5, myBezier"
              "windowsOut, 1, 7, default, popin 80%"
              "border, 1, 10, default"
              "fade, 1, 7, default"
              "workspaces, 1, 6, default"
            ];
          };
          misc = {
            vfr = false;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            focus_on_activate = false;
          };

          # Environment
          env = [
            # XDG
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            # QT
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_QPA_PLATFORMTHEME,qt5ct"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            # Other
            "GDK_BACKEND,wayland,x11,*"
            "SDL_VIDEODRIVER,wayland"
            "CLUTTER_BACKEND,wayland"
          ];

          # Keybinds
          ## Control keys
          "$mod" = "SUPER";
          "$modshift" = "SUPER SHIFT";
          "$modalt" = "SUPER ALT";
          "$modctl" = "SUPER CTRL";

          # Bindings
          binde = [
            # Resizing
            ## Arrow keys
            "$modctl, left, resizeactive, -10% 0"
            "$modctl, right, resizeactive, 10% 0"
            "$modctl, up, resizeactive, 0 -10%"
            "$modctl, down, resizeactive, 0 10%"
            ## Vim keys
            "$modctl, H, resizeactive, -10% 0"
            "$modctl, L, resizeactive, 10% 0"
            "$modctl, K, resizeactive, 0 -10%"
            "$modctl, J, resizeactive, 0 10%"

            # System volume up/down
            ",XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%+"
            ",XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume -l 1.25 @DEFAULT_AUDIO_SINK@ 5%-"

            # Media player volume up/down
            "CTRL,XF86AudioRaiseVolume, exec, ${pkgs.playerctl}/bin/playerctl volume 0.1+"
            "CTRL,XF86AudioLowerVolume, exec, ${pkgs.playerctl}/bin/playerctl volume 0.1-"

            # Brightness up/down
            ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%+"
            ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 10%-"
          ];
          bind =
            [
              # Spawners
              "$mod, Return, exec, $terminal"
              "$mod, SPACE, exec, $menu"
              "$mod, ESCAPE, exec, $lock"
              "$modshift, E, exit"

              # Moving focus
              ## Arrow keys
              "$mod, left, movefocus, l"
              "$mod, right, movefocus, r"
              "$mod, up, movefocus, u"
              "$mod, down, movefocus, d"
              ## Vim keys
              "$mod, H, movefocus, l"
              "$mod, L, movefocus, r"
              "$mod, K, movefocus, u"
              "$mod, J, movefocus, d"

              # Window control
              "$mod, V, togglefloating"
              "$mod, J, togglesplit"
              "$mod, F, fullscreen"
              "$mod, Q, killactive"

              # Move window
              ## Arrow keys
              "$modshift, left, movewindow, l"
              "$modshift, right, movewindow, r"
              "$modshift, up, movewindow, u"
              "$modshift, down, movewindow, d"
              ## Vim keys
              "$modshift, H, movewindow, l"
              "$modshift, L, movewindow, r"
              "$modshift, K, movewindow, u"
              "$modshift, J, movewindow, d"

              # Move workspaces
              ## Arrow keys
              "$modalt, left, movecurrentworkspacetomonitor, l"
              "$modalt, right, movecurrentworkspacetomonitor, r"
              "$modalt, up, movecurrentworkspacetomonitor, u"
              "$modalt, down, movecurrentworkspacetomonitor, d"
              ## Vim Keys
              "$modalt, H, movecurrentworkspacetomonitor, l"
              "$modalt, L, movecurrentworkspacetomonitor, r"
              "$modalt, K, movecurrentworkspacetomonitor, u"
              "$modalt, J, movecurrentworkspacetomonitor, d"

              # Screenshotting
              "$mod, PRINT, exec, ${pkgs.hyprshot} -m window"
              ", PRINT, exec, ${pkgs.hyprshot} -m output"
              "$modshift, PRINT, exec, ${pkgs.hyprshot} -m region"

              # Video recording
              "$mod, R, exec, ~/.config/hypr/scripts/screen-record.sh area"
              "$modshift, R, exec, ~/.config/hypr/scripts/screen-record.sh screen"
              "$mod, S, exec, ${pkgs.procps}/bin/pkill -INT wf-recorder && ${pkgs.libnotify}/bin/notify-send 'Screen Recording' 'Recording stopped.'"

              # Audio
              ## Volume mute
              ",XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
              ## Microphone mute
              ",XF86AudioMicMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

              # Media player
              ",XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
              ",XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
              ",XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
            ]
            ++ (
              # workspaces
              # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
              builtins.concatLists (builtins.genList (i: let
                  ws = i + 1;
                in [
                  "$mod, code:1${toString i}, workspace, ${
                    toString ws
                  }" # Switch workspace
                  "$modshift, code:1${toString i}, movetoworkspace, ${
                    toString ws
                  }" # Move window to workspace
                ])
                9)
            );
        };
      };

      home.file.".config/hypr/scripts/screen-record.sh" = {
        executable = true; # Make the script runnable
        text = ''
          #!/usr/bin/env bash

          # Directory to save recordings
          REC_DIR="$HOME/Videos/Screen-Recordings"
          mkdir -p "$REC_DIR"

          # Filename with timestamp
          FILENAME="$REC_DIR/rec_$(date +'%Y-%m-%d_%H-%M-%S').mp4"

          # System audio source (monitor of the default sink)
          SYSTEM_SOURCE="$(${pkgs.pulseaudio}/bin/pactl get-default-sink | sed 's/Name: //').monitor"

          # Check if a recording is already in progress
          if ${pkgs.procps}/bin/pgrep -x "wf-recorder" > /dev/null; then
              ${pkgs.libnotify}/bin/notify-send "Recording in Progress" "A screen recording is already active."
              exit 1
          fi

          # Main logic based on argument
          case $1 in
              area)
                  GEOMETRY=$(${pkgs.slurp})
                  if [ -n "$GEOMETRY" ]; then
                      ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Starting area recording with system audio..."
                      ${pkgs.wf-recorder} -g "$GEOMETRY" -f "$FILENAME" \
                          --audio="$SYSTEM_SOURCE"
                  else
                      ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Selection cancelled."
                  fi
                  ;;
              screen)
                  ${pkgs.libnotify}/bin/notify-send "Screen Recording" "Starting full-screen recording with system audio..."
                  ${pkgs.wf-recorder} -f "$FILENAME" \
                      --audio="$SYSTEM_SOURCE"
                  ;;
              *)
                  echo "Usage: $0 {area|screen}"
                  exit 1
                  ;;
          esac
        '';
      };
    };
  };
}
