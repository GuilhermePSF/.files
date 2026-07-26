{
  pkgs,
  lib,
  config,
  ...
}:

let
  cfg = config.steamModule;
in
{
  options.steamModule = {
    enable = lib.mkEnableOption "Enable Steam HM Module";

    enableExtraPackages = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Extra tools for Steam (MangoHud, Protontricks, Gamescope).";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        steam-run # Utility for running outside binaries inside Steam's FHS
      ]
      ++ lib.optionals cfg.enableExtraPackages [
        mangohud
        protontricks
        gamescope
      ];
  };
}
