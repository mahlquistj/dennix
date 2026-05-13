{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.audio = {pkgs, ...}: {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };
  };
}
