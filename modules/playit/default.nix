{ config, lib, pkgs, ... }:

{
  services.playit = {
    enable = true;
    secretPath = "/var/lib/playit/secret";
  };

  networking.firewall.allowedUDPPorts = [ 5523 ]; 
}