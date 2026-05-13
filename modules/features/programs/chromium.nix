{
  self,
  inputs,
  ...
}: {
  flake.homeModules.chromium = {pkgs, ...}: {
    programs.chromium = {
      enable = true;
      package = pkgs.chromium.override {
        # Enable widevine DRM (Netflix and other copyright content compat)
        enableWideVine = true;
      };
      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
      ];

      extensions = [
        # Extensions can be added here
      ];
    };
  };
}
