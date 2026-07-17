{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.jetbrainsModule.enable = lib.mkEnableOption "Enable JetBrains Module";

  config = lib.mkIf config.jetbrainsModule.enable {

    home.packages = with pkgs; [
      jetbrains.datagrip
    ];

    # JetBrains IDEs share a common VM options directory.
    # DataGrip reads ~/.config/JetBrains/DataGrip*/datagrip64.vmoptions
    # We use a version-agnostic glob-free path via a wrapper script instead,
    # but the simplest cross-version approach is the idea file:
    xdg.configFile."JetBrains/DataGrip.vmoptions".text = ''
      -Xms256m
      -Xmx2048m
      -XX:ReservedCodeCacheSize=512m
      -XX:+UseG1GC
      -Dawt.toolkit.name=WLToolkit
    '';
  };
}
