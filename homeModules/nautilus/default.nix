{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.nautilusModule.enable = lib.mkEnableOption "Enable Nautilus File Manager Module";

  config = lib.mkIf config.nautilusModule.enable {

    home.packages = with pkgs; [
      nautilus
      gvfs
      gnome-epub-thumbnailer
      ffmpegthumbnailer
      evince
      webp-pixbuf-loader
      sushi
      file-roller
      p7zip
      unzip
      zip
      unrar
      glib
      nautilus-python
      wl-clipboard
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-directory" = [ "org.gnome.Nautilus.desktop" ];
        "x-directory/normal" = [ "org.gnome.Nautilus.desktop" ];
        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-bzip2" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-gzip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-xz" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-zstd-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];
        "image/bmp" = [ "org.gnome.Loupe.desktop" ];
        "image/tiff" = [ "org.gnome.Loupe.desktop" ];
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };

    xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default=gnome
      org.freedesktop.impl.portal.FileChooser=gnome
      org.freedesktop.impl.portal.AppChooser=gnome
    '';

    dconf.settings = {
      "org/gnome/nautilus/preferences" = {
        default-folder-viewer = "list-view";
        show-hidden-files = false;
        show-create-link = true;
        show-delete-permanently = true;
        open-folder-on-dnd-hover = true;
        recursive-search = "local-only";
        search-filter-time-type = "last_modified";
      };
      "org/gnome/nautilus/list-view" = {
        default-zoom-level = "small";
        use-tree-view = true;
        default-column-order = [
          "name"
          "size"
          "type"
          "date_modified"
        ];
        default-visible-columns = [
          "name"
          "size"
          "type"
          "date_modified"
        ];
      };
      "org/gnome/nautilus/icon-view" = {
        default-zoom-level = "standard";
        captions = [
          "size"
          "date_modified"
          "none"
        ];
      };
      "org/gnome/nautilus/compression" = {
        default-compression-format = "zip";
      };
      "org/gtk/settings/file-chooser" = {
        show-hidden = false;
        sort-directories-first = true;
        location-mode = "path-bar";
        show-size-column = true;
        show-type-column = true;
        date-format = "with-time";
      };
      "org/gtk/gtk4/settings/file-chooser" = {
        show-hidden = false;
        sort-directories-first = true;
        location-mode = "path-bar";
        show-size-column = true;
        date-format = "with-time";
      };
    };

    home.file.".config/gtk-3.0/bookmarks".text = ''
      file://${config.homeDirectory}/UMINHO UMinho
      file://${config.homeDirectory}/Downloads Downloads
      file://${config.homeDirectory}/Documents Documents
      file://${config.homeDirectory}/Pictures Pictures
      file://${config.homeDirectory}/Videos Videos
      file://${config.homeDirectory}/Music Music
      file://${config.homeDirectory}/Pictures/Screenshots Screenshots
      file://${config.homeDirectory}/Pictures/Wallpapers Wallpapers
      file://${config.homeDirectory}/Documents/PDFs PDFs
      file://${config.homeDirectory}/dev Dev
      file://${config.homeDirectory}/Obsidian Obsidian Vault
      file://${config.nixosConfig} NixOS Config
      file://${config.homeDirectory}/Misc Misc
    '';

    home.file.".config/gtk-4.0/bookmarks".text = ''
      file://${config.homeDirectory}/UMINHO UMinho
      file://${config.homeDirectory}/Downloads Downloads
      file://${config.homeDirectory}/Documents Documents
      file://${config.homeDirectory}/Pictures Pictures
      file://${config.homeDirectory}/Videos Videos
      file://${config.homeDirectory}/Music Music
      file://${config.homeDirectory}/Pictures/Screenshots Screenshots
      file://${config.homeDirectory}/Pictures/Wallpapers Wallpapers
      file://${config.homeDirectory}/Documents/PDFs PDFs
      file://${config.homeDirectory}/dev Dev
      file://${config.homeDirectory}/Obsidian Obsidian Vault
      file://${config.nixosConfig} NixOS Config
      file://${config.homeDirectory}/Misc Misc
    '';

  };
}
