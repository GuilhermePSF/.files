{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.mediaModule.enable = lib.mkEnableOption "Enable Media Module";

  config = lib.mkIf config.mediaModule.enable {

    home.packages = with pkgs; [
      mpv # Wayland-native video player
      loupe # GNOME image viewer
    ];
  };
}
