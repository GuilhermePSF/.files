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
      # --- Core ---
      nautilus

      # --- GVFS backends (network mounts: SMB, MTP, SSH, Google Drive, FTP) ---
      gvfs # Core virtual filesystem (includes FUSE support)

      # --- Thumbnails & Previews ---
      gnome-epub-thumbnailer # ePub
      ffmpegthumbnailer # Video thumbnails
      evince # PDF previewer + viewer
      webp-pixbuf-loader # WebP image support in GTK

      # --- Quick Look / Spacebar preview (like macOS) ---
      sushi # Spacebar file previewer

      # --- Archive support (right-click extract/compress) ---
      file-roller # GNOME archive manager GUI
      p7zip
      unzip
      zip
      unrar

      # --- Image viewer ---
      eog # Eye of GNOME

      # --- Trash, bookmarks, monitoring ---
      glib # gio CLI (gio trash, gio open, etc.)

      # --- Nautilus extensions ---
      nautilus-python # Python extension API

      # --- Wayland clipboard ---
      wl-clipboard
    ];

    # ----------------------------------------------------------------
    # XDG MIME — Nautilus handles all directory/file open requests
    # ----------------------------------------------------------------
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        "application/x-directory" = [ "org.gnome.Nautilus.desktop" ];
        "x-directory/normal" = [ "org.gnome.Nautilus.desktop" ];

        # Archives → File Roller
        "application/zip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-tar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-bzip2" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-gzip" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-7z-compressed" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-rar" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-xz" = [ "org.gnome.FileRoller.desktop" ];
        "application/x-zstd-compressed-tar" = [ "org.gnome.FileRoller.desktop" ];

        # Images → Eye of GNOME
        "image/jpeg" = [ "org.gnome.eog.desktop" ];
        "image/png" = [ "org.gnome.eog.desktop" ];
        "image/gif" = [ "org.gnome.eog.desktop" ];
        "image/webp" = [ "org.gnome.eog.desktop" ];
        "image/svg+xml" = [ "org.gnome.eog.desktop" ];
        "image/bmp" = [ "org.gnome.eog.desktop" ];
        "image/tiff" = [ "org.gnome.eog.desktop" ];

        # PDFs → Evince
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };

    # ----------------------------------------------------------------
    # GNOME portal — file picker used by Brave, VSCode, Firefox, etc.
    # ----------------------------------------------------------------
    xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
      [preferred]
      default=gnome
      org.freedesktop.impl.portal.FileChooser=gnome
      org.freedesktop.impl.portal.AppChooser=gnome
    '';

    # ----------------------------------------------------------------
    # Nautilus preferences via dconf
    # ----------------------------------------------------------------
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
      # File chooser dialog (used by ALL apps via portal)
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

    # ----------------------------------------------------------------
    # Bookmarks (sidebar in Nautilus + all GTK file pickers)
    # ----------------------------------------------------------------
    home.file.".config/gtk-3.0/bookmarks".text = ''
      file:///home/gui/Downloads Downloads
      file:///home/gui/Obsidian Obsidian Vault
      file:///home/gui/nixos-config NixOS Config
    '';

  };
}
