{
  self,
  inputs,
  ...
}: {
  flake.homeModules.hyprland-waybar = {
    pkgs,
    lib,
    ...
  }: {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      style = lib.fileContents ./waybar.css;

      settings = [
        {
          position = "top";
          layer = "top";

          mod = "dock";

          height = 26;

          margin-left = 10;
          margin-right = 10;
          margin-top = 5;
          margin-bottom = 0;
          exclusive = true;
          passthrough = false;
          gtk-layer-shell = true;
          reload_style_on_change = true;

          modules-left = ["group/power" "tray"];
          modules-center = ["hyprland/workspaces"];
          modules-right = [
            "disk"
            "group/usage"
            "temperature"
            "group/meta"
            "clock"
            "battery"
          ];

          "group/meta" = {
            orientation = "horizontal";
            modules = [
              "wireplumber"
              "backlight"
              "network"
              "custom/notification"
            ];
          };

          "group/power" = {
            orientation = "horizontal";
            drawer = {
              transition-duration = 500;
              children-class = "other-btns";
              transition-left-to-right = true;
            };
            modules = [
              "custom/power"
              "custom/quit"
              "custom/lock"
              "custom/reboot"
            ];
          };

          "custom/quit" = {
            format = "󰗼";
            tooltip = true;
            on-click = "hyprctl dispatch exit";
            tooltip-format = "Logout";
          };
          "custom/lock" = {
            "format" = "󰍁";
            "tooltip" = true;
            "on-click" = "hyprctl dispatch exec hyprlock";
            tooltip-format = "Lock";
          };
          "custom/reboot" = {
            format = "󰜉";
            tooltip = true;
            on-click = "reboot";
            tooltip-format = "Reboot";
          };
          "custom/power" = {
            format = "";
            tooltip = true;
            on-click = "shutdown now";
            tooltip-format = "Shut down";
          };

          tray = {
            spacing = 5;
          };

          "hyprland/workspaces" = {
            format = "{name}";
          };

          disk = {
            format = "<span color='#cad3f5'></span> {percentage_used}%"; #TODO: Can the color be set in another way?
            tooltip-format = "{used} used out of {total} ({free} free)";

            states = {
              critical = 90;
              warning = 70;
              good = 0;
            };
          };

          "group/usage" = {
            orientation = "horizontal";
            modules = [
              "memory"
              "cpu"
            ];
          };

          memory = {
            format = "<span color='#cad3f5'></span> <span rise='-1000'>{icon}</span>"; #TODO: Can the color be set in another way?
            tooltip-format = "RAM: {used:0.1f}GiB of {total:0.1f}GiB used.\nSWAP: {swapUsed:0.1f}GiB of {swapTotal:0.1f}GiB used.";
            tooltip = true;
            format-icons = ["" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥"];
            states = {
              critical = 80;
              warning = 50; # We're over our normal ram - now using SWAP
              good = 0;
            };
          };

          cpu = {
            interval = 10;

            format = "<span color='#cad3f5'></span> <span rise='-1000'>{icon}</span>"; #TODO: Can the color be set in another way?
            format-icons = ["" "󰪞" "󰪟" "󰪠" "󰪡" "󰪢" "󰪣" "󰪤" "󰪥"];
            states = {
              critical = 90;
              warning = 70;
              good = 0;
            };
          };

          wireplumber = {
            format = "{icon}";
            format-muted = "";
            tooltip-format = "Open sound manager";
            format-icons = ["" "" ""];

            on-click = "hyprctl dispatch exec pavucontrol";
          };

          backlight = {
            format = "{icon}";
            format-icons = ["󰃞" "󰃟" "󰃠"];
            tooltip = false;
          };

          network = {
            format-ethernet = "󰈁";
            format-disconnected = "";
            format-wifi = "{icon}";

            tooltip-format-ethernet = ''
              Interface: {ifname}
              Gateway-IP: {gwaddr}
              IP: {ipaddr}
              Up: {bandwidthUpBytes}
              Down: {bandwidthDownBytes}
            '';
            tooltip-format-wifi = ''
              SSID: {essid}
              Signal: {signaldBm} dBm
              Freqency: {frequency} GHz
              Interface: {ifname}
              Gateway: {gwaddr}
              IP: {ipaddr}
              Up: {bandwidthUpBytes}
              Down: {bandwidthDownBytes}
            '';

            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];

            #TODO: on_click = "ADD COMMAND TO OPEN NETWORK MANAGER";
          };

          "custom/notification" = {
            tooltip = true;
            tooltip-format = "{} notification(s)";
            format = "<span rise='-1000'>{icon}</span>";
            format-icons = {
              notification = "";
              none = "";
              dnd-notification = "";
              dnd-none = "";
              inhibited-notification = "";
              inhibited-none = "";
              dnd-inhibited-notification = "";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t -sw";
            on-click-right = "swaync-client -d -sw";
            escape = true;
          };

          clock = {
            format = "{:%H:%M %d/%m/%Y}";
            tooltip-format = "{:%A | Week: %U}";
          };

          battery = {
            interval = 5;

            format = "{icon}";
            format-good = "{icon} {capacity}%";
            format-warning = "{icon} {capacity}%";
            format-critical = "{icon} {time}";

            format-charging = "󱐋 {capacity}%";
            format-charging-good = "󱐋 {capacity}%";
            format-charging-warning = "󱐋 {capacity}%";
            format-charging-critical = "󱐋 {capacity}%";

            format-time = "{H}:{M}";

            states = {
              good = 99;
              warning = 40;
              critical = 20;
            };

            format-icons = ["󰂃" "󰁽" "󰁿" "󰂁" "󱟢"];
          };
        }
      ];
    };
  };
}
