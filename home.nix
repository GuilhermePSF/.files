{ config, pkgs, lib, inputs, ... }:

{
  home.username = "gui";
  home.homeDirectory = "/home/gui";
  home.stateVersion = "25.11"; 
  home.enableNixpkgsReleaseCheck = false;

  niriModule.enable = true;
  gitModule.enable = true;
  zshModule.enable = true;
  hyprlandModule.enable = true;
  quickshellModule.enable = false;
  fastfetchModule.enable = true;
  ghosttyModule.enable = true;
  noctaliaModule.enable = true;
  minecraftModule.enable = false;
  vscodeModule.enable = true;

  imports = [
    ./modules/hyprland
    ./modules/niri
    ./modules/vscode
    ./modules/zsh
    ./modules/git
    ./modules/quickshell
    ./modules/fastfetch
    ./modules/ghostty
    ./modules/noctalia
    ./modules/minecraft
  ];
}