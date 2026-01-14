{ config, pkgs, lib, ... }:

let
  vscodeModule = import ./modules/vscode;
  hyprlandModule = import ./modules/hyprland;
  zshModule = import ./modules/zsh;
  gitModule = import ./modules/git;
  quickshellModule = import ./modules/quickshell;
  fastfetchModule = import ./modules/fastfetch;
  ghosttyModule = import ./modules/ghostty;
  noctaliaModule = import ./modules/noctalia;
  minecraftModule = import ./modules/minecraft;
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
  noctaliaModule.enable = true;
  minecraftModule.enable = true;

  imports = [
    hyprlandModule
    vscodeModule
    zshModule
    gitModule
    quickshellModule
    fastfetchModule
    ghosttyModule
    noctaliaModule
    minecraftModule
  ];
}