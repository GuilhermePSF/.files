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
