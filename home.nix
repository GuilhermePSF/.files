{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  home.username = "gui";
  home.homeDirectory = "/home/gui";
  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false;
  stylix.enableReleaseChecks = false;

  niriModule.enable = true;
  gitModule.enable = true;
  obsidianModule.enable = true;
  zshModule.enable = true;
  hyprlandModule.enable = true;
  quickshellModule.enable = false;
  fastfetchModule.enable = true;
  ghosttyModule.enable = true;
  noctaliaModule.enable = true;
  minecraftModule.enable = false;
  vscodeModule.enable = true;
  nhModule.enable = true;
  spicetifyModule.enable = true;
  braveModule.enable = true;
  firefoxModule.enable = true;
  nautilusModule.enable = true;
  neovimModule.enable = true;
  kritaModule.enable = true;
  vesktopModule.enable = true;
  slackModule.enable = true;
  jetbrainsModule.enable = true;
  organizeModule.enable = true;
  pavucontrolModule.enable = true;
  mediaModule.enable = true;
  devtoolsModule.enable = true;

  imports = [
    ./homeModules/hyprland
    ./homeModules/niri
    ./homeModules/vscode
    ./homeModules/zsh
    ./homeModules/git
    ./homeModules/quickshell
    ./homeModules/fastfetch
    ./homeModules/ghostty
    ./homeModules/noctalia
    ./homeModules/minecraft
    ./homeModules/nh
    ./homeModules/spicetify
    ./homeModules/obsidian
    ./homeModules/brave
    ./homeModules/firefox
    ./homeModules/nautilus
    ./homeModules/neovim
    ./homeModules/krita
    ./homeModules/vesktop
    ./homeModules/slack
    ./homeModules/jetbrains
    ./homeModules/organize
    ./homeModules/pavucontrol
    ./homeModules/media
    ./homeModules/devtools
  ];
}
