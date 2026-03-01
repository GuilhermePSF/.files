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

    # ----------------------------------------------------------------
    # Wayland flags — passed via the desktop entry wrapper env var
    # that Vesktop reads. This file is never written to by the app.
    # ----------------------------------------------------------------
    xdg.configFile."vesktop/settings.json" = {
      force = true; # overwrite but don't symlink — copy instead
      text = builtins.toJSON {
        discordBranch = "stable";
        arRPC = true;
        minimizeToTray = false;
        openLinksWithElectron = false;
        additionalArguments = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
      };
    };

    # ----------------------------------------------------------------
    # Stylix theme for Vesktop.
    # Stylix writes its generated theme to ~/.config/Vencord/themes/ but
    # Vesktop's bundled Vencord only reads from ~/.config/vesktop/themes/.
    # We point the vesktop themes dir at the same store path Stylix uses
    # for its Vencord target.
    # ----------------------------------------------------------------
    xdg.configFile."vesktop/themes/stylix.theme.css".source =
      config.xdg.configFile."Vencord/themes/stylix.theme.css".source;
  };
}
