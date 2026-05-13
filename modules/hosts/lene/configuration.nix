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

    # System packages
    environment.systemPackages = with pkgs; [
      # Add any system-wide packages you might need here
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

    # Time and internationalisation
    time.timeZone = "Europe/Copenhagen";
    location.provider = "geoclue2";
    console.keyMap = "dk";
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };
    };

    # udisks2 daemon
    services.udisks2.enable = true;

    # Nix settings
    nix = {
      settings.experimental-features = ["nix-command" "flakes"];
      # Cleanup rules
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
    users = {
      defaultUserShell = pkgs.bash;
      users.jdenn = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "wheel"];
      };
    };
    home-manager.users.jdenn = self.homeModules.jdenn;
  };
}
