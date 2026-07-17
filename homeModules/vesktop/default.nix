{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.vesktopModule.enable = lib.mkEnableOption "Enable Vesktop Module";

  config = lib.mkIf config.vesktopModule.enable {

    home.packages = [ pkgs.vesktop ];

    xdg.configFile."vesktop/settings.json" = {
      force = true;
      text = builtins.toJSON {
        discordBranch = "stable";
        arRPC = true;
        minimizeToTray = false;
        openLinksWithElectron = false;
        additionalArguments = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };

    xdg.configFile."vesktop/themes/stylix.theme.css".source =
      config.xdg.configFile."Vencord/themes/stylix.theme.css".source;
  };
}
