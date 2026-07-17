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
      # --- Video ---
      mpv # Wayland-native video player

      # --- Images ---
      loupe # GNOME image viewer
    ];
  };
}
