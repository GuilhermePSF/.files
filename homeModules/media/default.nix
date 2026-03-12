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

      # --- Photo management ---
      shotwell # Photo manager

      # --- Fonts ---
      font-manager # Browse & preview installed fonts

      # --- PDF ---
      masterpdfeditor4 # Proprietary garbage but fuckit
    ];
  };
}
