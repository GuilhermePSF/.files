{ config, pkgs, lib, ... }:

let
  vscodeModule = import ./modules/vscode;
  hyprlandModule = import ./modules/hyprland;
  zshModule = import ./modules/zsh;
  gitModule = import ./modules/git;
  quickshellModule = import ./modules/quickshell;
  fastfetchModule = import ./modules/fastfetch;
  ghosttyModule = import ./modules/ghostty;
in
{
  home.username = "gui";
  home.homeDirectory = "/home/gui";
  home.stateVersion = "25.05";

  zshModule.enable = true;
  hyprlandModule.enable = true;
  gitModule.enable = true;
  quickshellModule.enable = true;
  fastfetchModule.enable = true; 
  ghosttyModule.enable = true;

  imports = [
    hyprlandModule
    vscodeModule
    zshModule
    gitModule
    quickshellModule
    fastfetchModule
    ghosttyModule
  ];
}
