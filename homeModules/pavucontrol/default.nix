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
      pavucontrol
      helvum
      easyeffects
    ];
  };
}
