{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.quickshellModule.enable = lib.mkEnableOption "Enable Quickshell Module";

  config = lib.mkIf config.quickshellModule.enable {

    home.packages = [
      # Dependencies
      pkgs.quickshell
      pkgs.jq
      pkgs.nerd-fonts.jetbrains-mono
    ];

    xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  };
}
