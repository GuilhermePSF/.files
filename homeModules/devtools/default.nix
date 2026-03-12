{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.devtoolsModule.enable = lib.mkEnableOption "Enable Dev Tools Module";

  config = lib.mkIf config.devtoolsModule.enable {

    home.packages = with pkgs; [
      # --- JVM ---
      jdk21

      # --- Python ---
      python3
      python3Packages.uv
      python313Packages.scapy

    ];
  };
}
