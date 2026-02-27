{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.nhModule.enable = lib.mkEnableOption "Enable NH Module";

  config = lib.mkIf config.nhModule.enable {

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 24h --keep 5";
    };

  };
}
