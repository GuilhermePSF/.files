{ pkgs, lib, config, ... }:

{
  options.ghosttyModule.enable = lib.mkEnableOption "Enable Ghostty Module";

  config = lib.mkIf config.ghosttyModule.enable {

    home.packages = [ pkgs.ghostty ];

    # Write the Ghostty config file (to ~/.config/ghostty/config)
    xdg.configFile."ghostty/config".text = ''
      font-family = "FiraCode Nerd Font", "Symbols-Only Nerd Font"

      font-size = 12

      window-decoration = false

      theme = Catppuccin Mocha
    '';
  };
}
