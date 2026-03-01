{
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./confModules/boot.nix
    ./confModules/networking.nix
    ./confModules/desktop.nix
    ./confModules/audio.nix
    ./confModules/users.nix
    ./confModules/packages.nix
    ./confModules/stylix
    ./confModules/mounts.nix
  ];

  stylixModule.enable = true;

  time.timeZone = "Europe/Lisbon";
  system.stateVersion = "25.11";
}
