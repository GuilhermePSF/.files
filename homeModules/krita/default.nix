{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.kritaModule.enable = lib.mkEnableOption "Enable Krita Module";

  config = lib.mkIf config.kritaModule.enable {

    home.packages = [ pkgs.krita ];

    # Krita stores its config in ~/.config/kritarc (INI format).
    # We seed the most useful defaults; Krita merges unknown keys safely.
    xdg.configFile."kritarc".text = ''
      [General]
      theme=Dark
      EnableHiDPI=true
      hideSplashScreen=true

      [KisDocument]
      AutoSaveInterval=5

      [ColorManagement]
      WorkingColorSpace=sRGB
    '';
  };
}
