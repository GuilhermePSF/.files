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
      jdk21
      zig
      odin
      python3
      python3Packages.uv
      python313Packages.scapy
      bun
      nodejs_22
      rust-bin.stable.latest.default
    ];
  };
}
