{
  self,
  inputs,
  ...
}: {
  flake.homeModules.vicinae = {pkgs, ...}: {
    imports = [
      inputs.vicinae.homeManagerModules.default
    ];

    services.vicinae = {
      enable = true;
      systemd = {
        enable = true;
        autoStart = true;
        environment = {
          USE_LAYER_SHELL = 1;
        };
      };

      settings = {
        launcher_window.opacity = 0.98;
      };
    };
  };
}
