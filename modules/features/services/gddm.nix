{
  pkgs,
  inputs,
  ...
}: {
  flake.nixosModules.gddm = {pkgs, ...}: {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
