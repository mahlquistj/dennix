{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.gdm = {pkgs, ...}: {
    services.displayManager.gdm = {
      enable = true;
    };
  };
}
