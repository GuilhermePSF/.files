{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.cageModule;
in
{
  options.cageModule = {
    enable = mkEnableOption "Cage wayland kiosk compositor";
  };

  config = mkIf cfg.enable {
    # Create a script to launch Cage with Ghostty
    home.file.".local/bin/start-cage".text = ''
      #!/bin/sh
      exec ${pkgs.cage}/bin/cage -- ${pkgs.ghostty}/bin/ghostty
    '';

    home.file.".local/bin/start-cage".executable = true;

    home.sessionPath = [ "$HOME/.local/bin" ];

    # Create a systemd user service to auto-start Cage
    systemd.user.services.cage = {
       Unit = {
         Description = "Cage Wayland compositor with Ghostty";
         After = [ "graphical-session-pre.target" ];
       };
       Service = {
         ExecStart = "${config.home.homeDirectory}/.local/bin/start-cage";
         Restart = "on-failure";
       };
       Install = {
         WantedBy = [ "graphical-session.target" ];
       };
     };
  };
}