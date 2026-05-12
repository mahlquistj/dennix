{
  self,
  inputs,
  ...
}: {
  # Nixos configuration entry point
  flake.nixosConfigurations.Lene = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.Lene
      self.nixosModules.myHomeManager
    ];
  };

  # Actual nixos configuration
  flake.nixosModules.Lene = {pkgs, ...}: {
    imports = [
      ./hardware-configuration.nix
      self.nixosModules.hyprland
    ];

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

    # Users settings
    users.users.jdenn = {
      isNormalUser = true;
      shell = pkgs.bash;
    };
    home-manager.users.jdenn = self.homeModules.jdenn;

    # System packages
    environment.systemPackages = with pkgs; [
      udiskie
    ];
  };
}
