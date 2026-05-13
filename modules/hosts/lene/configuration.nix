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
      ./hardware-configuration.nix
      hyprland
      audio
    ];

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
        efi.canTouchEferVariables = true;
      };
    };

    # Cleanup rules
    nix = {
      # Try optimizing the nix store automatically
      optimise.automatic = true;
      gc = {
        automatic = true;
        randomizedDelaySec = "14m";
        # Remove generations older than 10 days
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
