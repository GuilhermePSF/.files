{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  userConfig = import ./config.nix;
in
{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "25.11";
  home.enableNixpkgsReleaseCheck = false;
  stylix.enableReleaseChecks = false;

  # Conditionally enable the selected desktop environment
  niriModule.enable = userConfig.desktop == "niri";
  hyprlandModule.enable = userConfig.desktop == "hyprland";
  gnomeModule.enable = userConfig.desktop == "gnome";

  # General modules
  gitModule.enable = true;
  obsidianModule.enable = true;
  zshModule.enable = true;
  fastfetchModule.enable = true;
  ghosttyModule.enable = true;
  noctaliaModule.enable = true;
  minecraftModule.enable = false;
  vscodeModule.enable = true;
  zedModule.enable = true;
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
  organizeModule.enable = false;
  pavucontrolModule.enable = true;
  mediaModule.enable = true;
  devtoolsModule.enable = true;
  steamModule.enable = true;

  imports = [
    ./homeModules/gnome
    ./homeModules/hyprland
    ./homeModules/niri
    ./homeModules/vscode
    ./homeModules/zed
    ./homeModules/zsh
    ./homeModules/git
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
    ./homeModules/steam

    # External Home Manager modules
    inputs.zed-extensions.homeManagerModules.default
  ];
}
