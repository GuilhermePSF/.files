{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.organizeModule.enable = lib.mkEnableOption "Enable organize-tool file sorting";

  config = lib.mkIf config.organizeModule.enable {

    home.packages = with pkgs; [ uv ];

    # ~/.local/bin is where uv installs tool binaries — make sure it's in PATH
    home.sessionPath = [ "$HOME/.local/bin" ];

    # organize-tool is not yet packaged in nixpkgs 25.11 — install via uv.
    # uv tool install is idempotent so this is safe to run on every switch.
    home.activation.installOrganizeTool = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD ${pkgs.uv}/bin/uv tool install --quiet organize-tool || true
    '';

    # ----------------------------------------------------------------
    # organize-tool config — ~/.config/organize-tool/config.yaml
    # Rules run top-to-bottom; first match wins, so specific rules
    # (CVs, Wallpapers) always come before their broader siblings
    # (PDFs, Images).
    # ----------------------------------------------------------------
    xdg.configFile."organize/config.yaml".text = ''
      rules:

        # ── PICTURES ────────────────────────────────────────────────

        - name: "Screenshots (hyprshot) from Pictures"
          locations:
            - ~/Pictures
          subfolders: false
          filters:
            - name:
                startswith: "hyprshot"
          actions:
            - move: ~/Pictures/Screenshots/

        - name: "Screenshots (hyprshot) from home root"
          locations:
            - path: ~
          subfolders: false
          filters:
            - regex: '^\d{4}-\d{2}-\d{2}-\d{6}_hyprshot\.png$'
          actions:
            - move: ~/Pictures/Screenshots/

        - name: "Wallpapers from Downloads"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - name:
                contains: "wallpaper"
                case_sensitive: false
            - extension:
                - jpg
                - jpeg
                - png
                - webp
                - bmp
                - tiff
          actions:
            - move: ~/Pictures/Wallpapers/

        # ── DOCUMENTS ───────────────────────────────────────────────

        - name: "CVs and Résumés"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension: pdf
            - name:
                contains:
                  - CV
                  - Curriculo
                  - Curriculum
                  - Resume
                  - Resumo
                case_sensitive: false
          actions:
            - move: ~/Documents/CVs/

        - name: "PDFs"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension: pdf
          actions:
            - move: ~/Documents/PDFs/

        - name: "Office and Spreadsheets"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - xlsx
                - xls
                - csv
                - ods
                - docx
                - doc
                - pptx
                - odt
                - odp
          actions:
            - move: ~/Documents/Office/

        - name: "Ebooks"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - epub
                - mobi
                - azw
                - azw3
                - fb2
          actions:
            - move: ~/Documents/Books/

        # ── MEDIA ───────────────────────────────────────────────────

        - name: "Vector and Design files"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - svg
                - ai
                - psd
                - xcf
                - kra
                - fig
                - sketch
          actions:
            - move: ~/Pictures/Design/

        - name: "Images from Downloads"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - jpg
                - jpeg
                - png
                - gif
                - webp
                - bmp
                - tiff
                - heic
                - avif
          actions:
            - move: ~/Pictures/Downloaded/

        - name: "Videos"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - mp4
                - mkv
                - avi
                - mov
                - webm
                - flv
                - wmv
                - h2d
          actions:
            - move: ~/Videos/

        - name: "Audio"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - mp3
                - flac
                - ogg
                - wav
                - aac
                - m4a
                - opus
          actions:
            - move: ~/Music/

        # ── DEV / SYSTEM ────────────────────────────────────────────

        - name: "Fonts"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - ttf
                - otf
                - woff
                - woff2
          actions:
            - move: ~/dev/assets/Fonts/

        - name: "Virtual machine and disk images"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - ova
                - vmdk
                - qcow2
                - iso
                - img
                - vhd
                - vdi
          actions:
            - move: "~/VirtualBox VMs/"

        - name: "Archives and Installers"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - zip
                - tar
                - gz
                - bz2
                - xz
                - 7z
                - rar
                - deb
                - rpm
                - AppImage
          actions:
            - move: ~/Downloads/Archives/

        - name: "Database files"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - sql
                - db
                - sqlite
                - sqlite3
                - dump
          actions:
            - move: ~/dev/databases/

        # ── WEB / MISC ───────────────────────────────────────────────

        - name: "HTML and Web exports"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - html
                - htm
                - mhtml
          actions:
            - move: ~/Downloads/WebExports/

        - name: "Torrent files"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - torrent
          actions:
            - move: ~/Downloads/Torrents/

        - name: "Config and dotfile exports"
          locations:
            - ~/Downloads
          subfolders: false
          filters:
            - extension:
                - json
                - yaml
                - yml
                - toml
                - ini
                - conf
                - env
          actions:
            - move: ~/Downloads/Configs/

        # ── HOME ROOT CLEANUP ────────────────────────────────────────

        - name: "Loose files in home root (non-nix)"
          locations:
            - path: ~
          subfolders: false
          filters:
            - not extension: nix
            - extension
          actions:
            - move: ~/Misc/

        # ── FALLBACK ────────────────────────────────────────────────

        - name: "Catch-all"
          locations:
            - ~/Downloads
          subfolders: false
          actions:
            - move: ~/Misc/
    '';

    # organize run is one-shot — no daemon mode exists.
    # We use a systemd timer to run it every 5 minutes.
    systemd.user.services.organize-tool = {
      Unit.Description = "organize-tool: sort files";
      Service = {
        Type = "oneshot";
        ExecStart = "%h/.local/bin/organize run";
        Environment = "PATH=%h/.local/bin";
      };
    };

    systemd.user.timers.organize-tool = {
      Unit.Description = "organize-tool timer (every 5 min)";
      Timer = {
        OnBootSec = "2min";
        OnUnitActiveSec = "5min";
        Persistent = true;
      };
      Install.WantedBy = [ "timers.target" ];
    };

    # Ensure all destination directories exist
    home.activation.createOrganizeDirs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      for dir in \
        "$HOME/Pictures/Screenshots" \
        "$HOME/Pictures/Wallpapers" \
        "$HOME/Pictures/Downloaded" \
        "$HOME/Pictures/Design" \
        "$HOME/Documents/CVs" \
        "$HOME/Documents/PDFs" \
        "$HOME/Documents/Office" \
        "$HOME/Documents/Books" \
        "$HOME/Videos" \
        "$HOME/Music" \
        "$HOME/dev/assets/Fonts" \
        "$HOME/dev/databases" \
        "$HOME/Downloads/Archives" \
        "$HOME/Downloads/WebExports" \
        "$HOME/Downloads/Torrents" \
        "$HOME/Downloads/Configs" \
        "$HOME/Misc"
      do
        $DRY_RUN_CMD mkdir -p "$dir"
      done
    '';
  };
}
