{ pkgs, lib, config, inputs, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  options.spicetifyModule.enable = lib.mkEnableOption "Enable Spicetify Module";

  config = lib.mkIf config.spicetifyModule.enable {

    programs.spicetify = {
      enable = true;

      # --- THEME ---
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      # --- EXTENSIONS ---
      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
        beautifulLyrics
        coverAmbience
        popupLyrics
        fullAppDisplay
        keyboardShortcut
        volumePercentage
        autoSkipExplicit
        playNext
        history
        songStats
        seekSong
        sleepTimer
        lastfm
      ];

      # --- WAYLAND ---
      wayland = null;

      # --- MISC ---
      alwaysEnableDevTools = false;
    };
  };
}