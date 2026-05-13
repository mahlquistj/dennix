{
  self,
  inputs,
  ...
}: {
  # Nixos configuration entry point
  flake.nixosConfigurations.lene = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.lene
      self.nixosModules.myHomeManager
    ];
  };

  # Actual nixos configuration
  flake.nixosModules.lene = {pkgs, ...}: {
    imports = with self.nixosModules; [
      # Hardware configuration - Always needed.
      # Describes the actual hardware of the system
      ./hardware-configuration.nix

      # Hyprland system dependencies
      hyprland

      # GDM lockscreen
      gdm

      # Audio dependencies
      audio
    ];

    # Fonts
    fonts = {
      packages = with pkgs; [
        twemoji-color-font
        google-fonts
        nerd-fonts.sauce-code-pro
      ];
    };

    # Networking
    networking = {
      hostName = "Lene";
      networkmanager.enable = true;
      firewall.enable = true;
    };

    # Security
    security = {
      sudo.enable = true;
      polkit.enable = true;
    };

    # Boot options
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
    };

    # Cleanup rules
    nix = {
      optimise.automatic = true;
      gc = {
        automatic = true;
        randomizedDelaySec = "14m";
        options = "--delete-older-than 10d";
      };
    };

    # Allow unfree software
    nixpkgs.config.allowUnfree = true;

    # Users settings
    users.users.jdenn = {
      isNormalUser = true;
      shell = pkgs.bash;
    };
    home-manager.users.jdenn = self.homeModules.jdenn;

    # System packages
    environment.systemPackages = with pkgs; [
    ];
  };
}
