{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.pavucontrolModule.enable = lib.mkEnableOption "Enable PulseAudio/PipeWire Volume Control Module";

  config = lib.mkIf config.pavucontrolModule.enable {

    home.packages = with pkgs; [
      # --- Volume control ---
      pavucontrol # Per-app volume control (works with PipeWire)

      # --- PipeWire patchbay / graph ---
      helvum # Visual PipeWire graph patcher

      # --- Audio effects ---
      easyeffects # EQ & effects per app via PipeWire
    ];
  };
}
