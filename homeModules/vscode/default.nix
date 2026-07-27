{
  pkgs,
  lib,
  config,
  ...
}:

let
  vscodeSettings = {
    # ==========================================================
    # Appearance
    # ==========================================================
    "workbench.colorTheme" = "One Dark Pro Flat";
    "workbench.iconTheme" = "material-icon-theme";

    "window.titleBarStyle" = "custom";
    "window.customTitleBarVisibility" = "never";
    "window.menuBarVisibility" = "hidden";
    "window.commandCenter" = false;
    "workbench.statusBar.visible" = false;

    "workbench.sideBar.location" = "right";
    "workbench.activityBar.location" = "hidden";
    "workbench.secondarySideBar.defaultVisibility" = "hidden";

    "breadcrumbs.enabled" = false;
    "editor.minimap.enabled" = false;
    "editor.stickyScroll.enabled" = false;

    "workbench.editor.empty.hint" = "hidden";
    "workbench.layoutControl.enabled" = false;

    # ==========================================================
    # Editor
    # ==========================================================
    "editor.fontFamily" = "FiraCode Nerd Font Mono";
    "editor.fontLigatures" = true;

    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    "editor.formatOnSave" = true;
    "editor.formatOnPaste" = true;

    "editor.largeFileOptimizations" = false;
    "editor.unicodeHighlight.invisibleCharacters" = false;

    "diffEditor.ignoreTrimWhitespace" = false;

    # ==========================================================
    # Explorer
    # ==========================================================
    "explorer.confirmDragAndDrop" = false;
    "workbench.editor.closeOnFileDelete" = true;
    "workbench.tree.indent" = 20;

    # ==========================================================
    # Files
    # ==========================================================
    "files.autoSave" = "afterDelay";

    "files.associations" = {
      "*.md" = "markdown";
    };

    # ==========================================================
    # Terminal
    # ==========================================================
    "terminal.integrated.fontLigatures.enabled" = true;

    # ==========================================================
    # Formatting
    # ==========================================================
    "prettier.singleQuote" = true;
    "prettier.trailingComma" = "all";

    "[jsonc]" = {
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };

    "[c]" = {
      "editor.defaultFormatter" = "ms-vscode.cpptools";
    };

    # ==========================================================
    # Language Support
    # ==========================================================
    "javascript.updateImportsOnFileMove.enabled" = "always";
    "typescript.updateImportsOnFileMove.enabled" = "always";

    "zig.zls.enabled" = "on";
    "svg.preview.mode" = "svg";

    # ==========================================================
    # Markdown
    # ==========================================================
    "markdown.preview.openMarkdownLinks" = "inPreview";

    "workbench.editorAssociations" = {
      "*.copilotmd" = "vscode.markdown.preview.editor";
      "*.md" = "markdown.preview.editor";
      "*.db" = "default";
    };

    # ==========================================================
    # Copilot
    # ==========================================================
    "github.copilot.enable" = {
      "*" = true;
      "plaintext" = false;
      "markdown" = false;
      "scminput" = false;
      "c" = true;
    };

    "github.copilot.nextEditSuggestions.enabled" = true;

    # ==========================================================
    # Misc
    # ==========================================================
    "http.systemCertificatesNode" = true;
    "vim.active" = false;

    "extensions.autoUpdate" = false;
    "extensions.autoCheckUpdates" = true;

    # ==========================================================
    # Spell Checker
    # ==========================================================
    "cSpell.userWords" = [
      "autoresize"
      "commenters"
      "echarts"
      "favourites"
      "Yari"
    ];
  };

  # Extensions available directly from nixpkgs' vscode-extensions set.
  nixpkgsExtensions = with pkgs.vscode-extensions; [
    # --- Copilot ---
    github.copilot
    github.copilot-chat

    # --- C/C++ ---
    llvm-vs-code-extensions.vscode-clangd

    # --- Python ---
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-pylance

    # --- Remote Development ---
    ms-azuretools.vscode-docker
    ms-vscode-remote.remote-ssh

    # --- Java (fixes JDK path errors) ---
    redhat.java
    vscjava.vscode-gradle
    vscjava.vscode-java-debug
    vscjava.vscode-java-dependency
    vscjava.vscode-java-pack
    vscjava.vscode-java-test
    vscjava.vscode-maven

    # --- Other Compiled Languages ---
    danielgavin.ols
    golang.go
    haskell.haskell
    rust-lang.rust-analyzer
    ziglang.vscode-zig

    # --- Tools ---
    jnoortheen.nix-ide
    usernamehw.errorlens
  ];

  # Extensions only available via the community marketplace overlay
  # (nix-vscode-extensions or similar), not packaged in nixpkgs proper.
  marketplaceExtensions = with pkgs.vscode-marketplace; [
    # --- Formatting / Git / JS-Web Tools ---
    bradlc.vscode-tailwindcss
    dbaeumer.vscode-eslint
    eamodio.gitlens
    esbenp.prettier-vscode
    mhutchie.git-graph
    pkief.material-icon-theme
    ritwickdey.liveserver
    vue.volar

    # --- Language-Specific Tools ---
    jakebecker.elixir-ls
    justusadam.language-haskell

    # --- Misc / File-Type Tools ---
    caponetto.vscode-diff-viewer
    guilhermepsf23.livevue-sigil-highlighting
    jock.svg
    mechatroner.rainbow-csv
    myriad-dreamin.tinymist
    pfwobcke.vscode-ttf
    phoenixframework.phoenix
    plibither8.remove-comments
    tomoki1207.pdf
    twxs.cmake
    zhuangtongfa.material-theme

    # --- Build Tools ---
    ms-vscode.makefile-tools
  ];
in

{
  options.vscodeModule.enable = lib.mkEnableOption "Enable VSCode module";

  config = lib.mkIf config.vscodeModule.enable {

    stylix.targets.vscode.enable = false;

    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;

    # STILL CANT FIGURE OUT HOW TO REMOVE THE FOCKING TITLE BAR DECORATIONS
     package = (pkgs.symlinkJoin {
        name = "vscode-no-decorations";
        paths = [ pkgs.vscode ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/code \
            --unset NIXOS_OZONE_WL \
            --add-flags "--ozone-platform-hint=auto" \
            --add-flags "--disable-features=WaylandWindowDecorations" \
            --add-flags "--enable-wayland-ime=true" \
            --add-flags "--wayland-text-input-version=3"
        '';
      }) // { inherit (pkgs.vscode) pname version; };

      profiles.default = {
        userSettings = vscodeSettings;
        extensions = nixpkgsExtensions ++ marketplaceExtensions;
      };
    };

    home.file = {
      ".config/Code/User/snippets/nix.json".text = builtins.toJSON {
        "Nix Shell (Zsh)" = {
          "prefix" = "nixzsh";
          "body" = [
            "{ pkgs ? import <nixpkgs> {} }:"
            ""
            "pkgs.mkShell {"
            "  nativeBuildInputs = with pkgs; ["
            "    $1"
            "  ];"
            ""
            "  # Automatically swap to zsh"
            "  shellHook = ''"
            "    exec zsh"
            "  '';"
            "}"
          ];
          "description" = "Create a nix shell that opens zsh directly";
        };
      };
    };
  };
}
