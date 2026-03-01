{ ... }:

{
  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.resolvconf.enable = false;

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
  };
}
