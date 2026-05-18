{
  self,
  inputs,
  ...
}: {
  flake.homeModules.git = {pkgs, ...}: {
    programs.git = {
      enable = true;
      settings = {
        push = {
          autoSetupRemote = true;
        };
      };
    };
  };
}
