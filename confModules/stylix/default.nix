{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.stylixModule.enable = lib.mkEnableOption "Enable Stylix Module";

  config = lib.mkIf config.stylixModule.enable {
    stylix = {
      enable = true;
      autoEnable = true;
      enableReleaseChecks = false;

      image = ./wallpaper.jpg;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };

      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Mono";
        };
        sansSerif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Sans";
        };
        serif = {
          package = pkgs.dejavu_fonts;
          name = "DejaVu Serif";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };
      };

      # System-level targets only — home-manager targets live in their own modules
      targets = {
        gtk.enable = true;
        qt.enable = true;
        plymouth.enable = true;
        grub.enable = false; # using systemd-boot
        console.enable = true;
      };
    };
  };
}
