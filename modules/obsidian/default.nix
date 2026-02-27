{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.obsidianModule.enable = lib.mkEnableOption "Enable Obsidian Module";

  config = lib.mkIf config.obsidianModule.enable {

    home.packages = with pkgs; [
      obsidian
    ];

    # ----------------------------------------------------------------
    # Vault directory (the actual notes live in ~/Obsidian)
    # ----------------------------------------------------------------
    home.file."Obsidian/.keep".text = "";

    # ----------------------------------------------------------------
    # Global Obsidian config  (~/.config/obsidian/obsidian.json)
    # Tells Obsidian where the vault lives and enables the GPU sandbox
    # fix required on NixOS (Electron + Wayland).
    # ----------------------------------------------------------------
    xdg.configFile."obsidian/obsidian.json".text = builtins.toJSON {
      vaults = {
        # The key is arbitrary – Obsidian uses it as an internal ID
        "guilhermesVault" = {
          path = "${config.home.homeDirectory}/Obsidian/GUIs Vault";
          ts = 1700000000000; # static timestamp is fine
          open = true;
        };
      };
    };

    # ----------------------------------------------------------------
    # Per-vault settings  (~/Obsidian/GUIs Vault/.obsidian/)
    # ----------------------------------------------------------------

    # app.json – core editor/UI behaviour
    home.file."Obsidian/GUIs Vault/.obsidian/app.json".text = builtins.toJSON {
      promptDelete = false;
      legacyEditor = false;
      defaultViewMode = "preview";
      livePreview = true;
      spellcheck = true;
      spellcheckLanguages = [
        "en"
        "pt"
      ];
      showLineNumber = true;
      foldHeading = true;
      foldIndent = true;
      readableLineLength = false;
      strictLineBreaks = false;
      showFrontmatter = true;
    };

    # appearance.json – theme & UI chrome
    home.file."Obsidian/GUIs Vault/.obsidian/appearance.json".text = builtins.toJSON {
      theme = "Tokyo Night";
      colorScheme = "obsidian";
      cssTheme = "Tokyo Night";
      accentColor = "#82AAFF";
      interfaceFontFamily = "FiraCode Nerd Font";
      textFontFamily = "FiraCode Nerd Font";
      monospaceFontFamily = "FiraCode Nerd Font Mono";
      baseFontSize = 16;
      nativeMenus = false;
      showViewHeader = true;
      cssEnabledSnippets = [ ];
    };

    # Tokyo Night theme CSS
    home.file."Obsidian/GUIs Vault/.obsidian/themes/Tokyo Night/theme.css".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/tcmmichaelb139/obsidian-tokyonight/main/theme.css";
      sha256 = "0ddk22h57r0wx62whb9679jchgy1fvx5v1n42acw7y9fycz8a7zp";
    };

    # Tokyo Night theme manifest
    home.file."Obsidian/GUIs Vault/.obsidian/themes/Tokyo Night/manifest.json".text = builtins.toJSON {
      name = "Tokyo Night";
      version = "1.1.6";
      minAppVersion = "0.0.1";
      author = "tcmmichaelb139";
    };

    # Style Settings – Moon variant colours
    home.file."Obsidian/GUIs Vault/.obsidian/plugins/obsidian-style-settings/data.json".text = builtins.toJSON {
      "Appearance@@red@@dark" = "#FF757F";
      "Appearance@@red1@@dark" = "#C53B53";
      "Appearance@@green@@dark" = "#C3E88D";
      "Appearance@@cyan@@dark" = "#86E1FC";
      "Appearance@@blue@@dark" = "#82AAFF";
      "Appearance@@yellow@@dark" = "#FFC777";
      "Appearance@@orange@@dark" = "#FF966C";
      "Appearance@@magenta@@dark" = "#C099FF";
      "Appearance@@bg@@dark" = "#222436";
      "Appearance@@bg_dark@@dark" = "#1E2030";
      "Appearance@@bg_highlight@@dark" = "#2F334D";
      "Appearance@@bg_highlight_dark@@dark" = "#1E2030";
      "Appearance@@bg_dark2@@dark" = "#191B29";
      "Appearance@@text-normal@@dark" = "#C8D3F5";
      "Appearance@@text-muted@@dark" = "#828BB8";
      "Appearance@@text-faint@@dark" = "#828BB8";
    };

    # core-plugins.json – enables/disables built-in plugins
    home.file."Obsidian/GUIs Vault/.obsidian/core-plugins.json".text = builtins.toJSON {
      "file-explorer" = true;
      "global-search" = true;
      "switcher" = true;
      "graph" = true;
      "backlink" = true;
      "canvas" = true;
      "outgoing-link" = true;
      "tag-pane" = true;
      "properties" = true;
      "page-preview" = true;
      "daily-notes" = true;
      "templates" = true;
      "note-composer" = true;
      "command-palette" = true;
      "slash-command" = true;
      "editor-status" = true;
      "bookmarks" = true;
      "markdown-importer" = false;
      "zk-prefixer" = false;
      "random-note" = false;
      "outline" = true;
      "word-count" = true;
      "slides" = false;
      "audio-recorder" = false;
      "workspaces" = true;
      "file-recovery" = true;
      "publish" = false;
      "sync" = false;
      "webviewer" = false;
      "footnotes" = true;
      "bases" = true;
    };

    # Community plugins list (enables style-settings)
    home.file."Obsidian/GUIs Vault/.obsidian/community-plugins.json".text = builtins.toJSON [
      "obsidian-style-settings"
    ];

    home.file."Obsidian/GUIs Vault/.obsidian/templates.json".text = builtins.toJSON {
      folder = "4 - Zettelkasten/A - Templates";
    };

    home.file."Obsidian/GUIs Vault/.obsidian/hotkeys.json".text = builtins.toJSON {
      "insert-template" = [
        {
          modifiers = [ "Alt" ];
          key = "T";
        }
      ];

      # Quick switcher
      "switcher:open" = [
        {
          modifiers = [ "Ctrl" ];
          key = "O";
        }
      ];

      # Command palette
      "command-palette:open" = [
        {
          modifiers = [ "Ctrl" ];
          key = "P";
        }
      ];

      # Toggle reading / live-preview view
      "markdown.toggle-preview" = [
        {
          modifiers = [ "Ctrl" ];
          key = "E";
        }
      ];

      # Graph view
      "graph:open" = [
        {
          modifiers = [ "Ctrl" ];
          key = "G";
        }
      ];

      # New note
      "app:create-new-note" = [
        {
          modifiers = [
            "Ctrl"
            "Shift"
          ];
          key = "N";
        }
      ];

      # Daily note
      "daily-notes" = [
        {
          modifiers = [ "Ctrl" ];
          key = "D";
        }
      ];

      # Search in all files
      "global-search:open" = [
        {
          modifiers = [
            "Ctrl"
            "Shift"
          ];
          key = "F";
        }
      ];
    };

    home.file."Obsidian/GUIs Vault/.obsidian/graph.json".text = builtins.toJSON {
      collapse-filter = false;
      search = "";
      showTags = false;
      showAttachments = false;
      hideUnresolved = false;
      showOrphans = true;
      collapse-color-groups = false;
      colorGroups = [ ];
      collapse-display = false;
      showArrow = false;
      textFadeMultiplier = 0;
      nodeSizeMultiplier = 1;
      lineSizeMultiplier = 1;
      collapse-forces = false;
      centerStrength = 0.518713248970312;
      repelStrength = 10;
      linkStrength = 1;
      linkDistance = 250;
      scale = 1;
      close = false;
    };

    # daily-notes.json – daily notes config
    home.file."Obsidian/GUIs Vault/.obsidian/daily-notes.json".text = builtins.toJSON {
      folder = "1 - Raw Notes";
      format = "YYYY-MM-DD";
      template = "4 - Zettelkasten/A - Templates/Daily Note";
    };
  };
}
