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
    imports = [
      self.homeModules.hyprland
    ];

    home.packages = with pkgs; [
    ];

    services = {
      # Automount USB's
      udiskie.enable = true;
    };

    home.stateVersion = "24.11";
  };
}
