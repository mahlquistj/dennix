{
  self,
  input,
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
