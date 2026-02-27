{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.vscodeModule.enable = lib.mkEnableOption "Enable VSCode module";

  config = lib.mkIf config.vscodeModule.enable {
    programs.vscode = {
      enable = true;
      mutableExtensionsDir = false;

      profiles.default.extensions =
        with pkgs.vscode-extensions;
        [
          # --- Copilot ---
          github.copilot
          github.copilot-chat

          # --- C/C++ ---
          ms-vscode.cpptools

          # --- Python ---
          ms-python.python
          ms-python.vscode-pylance
          ms-python.debugpy

          # --- Remote Development ---
          ms-vscode-remote.remote-ssh
          ms-azuretools.vscode-docker

          # --- Java (Fixes JDK path errors) ---
          vscjava.vscode-java-pack
          vscjava.vscode-java-debug
          vscjava.vscode-java-dependency
          vscjava.vscode-java-test
          vscjava.vscode-maven
          vscjava.vscode-gradle
          redhat.java

          # --- Other Compiled Languages ---
          golang.go # Go tools often need patching
          haskell.haskell # Haskell GHC paths

          # --- Tools ---
          # vscodevim.vim
        ]

        ++ (with pkgs.vscode-marketplace; [
          # --- Your Marketplace Specific List ---
          amatiasq.sort-imports
          astro-build.astro-vscode
          bundlecoverage.vue3-import-auto-correct
          caponetto.vscode-diff-viewer
          cweijan.dbclient-jdbc
          cweijan.vscode-mysql-client2
          edonet.vscode-command-runner
          formulahendry.auto-rename-tag
          guilhermepsf23.livevue-sigil-highlighting
          heybourn.headwind
          jock.svg
          mechatroner.rainbow-csv
          myriad-dreamin.tinymist
          nifate.min-theme-plus
          pfwobcke.vscode-ttf
          phoenixframework.phoenix
          plibither8.remove-comments
          potatochowon9.darkpdf
          shd101wyy.markdown-preview-enhanced
          shengchen.vscode-checkstyle
          steoates.autoimport
          sygene.auto-correct
          tomoki1207.pdf
          wix.vscode-import-cost
          zarifprogrammer.tailwind-snippets

          # --- Standard JS/Web Tools ---
          bbenoist.nix
          esbenp.prettier-vscode
          editorconfig.editorconfig
          usernamehw.errorlens
          eamodio.gitlens
          mhutchie.git-graph
          dbaeumer.vscode-eslint
          vue.volar
          bradlc.vscode-tailwindcss
          ritwickdey.liveserver
          yoavbls.pretty-ts-errors
          pkief.material-icon-theme
          tamasfe.even-better-toml

          # --- Specific Language Tools ---
          jakebecker.elixir-ls
          justusadam.language-haskell
        ]);

      # --------------------------------------------------------
      # SETTINGS
      # --------------------------------------------------------
      userSettings = {
        "workbench.colorTheme" = "Min Theme+";

        "[jsonc]" = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
        };
        "editor.formatOnSave" = true;
        "editor.fontFamily" = "FiraCode Nerd Font Mono";
        "files.autoSave" = "afterDelay";
        "workbench.editor.closeOnFileDelete" = true;
        "terminal.integrated.fontLigatures.enabled" = true;
        "workbench.sideBar.location" = "right";
        "window.menuBarVisibility" = "compact";
        "workbench.statusBar.visible" = true;
        "editor.fontLigatures" = true;
        "prettier.singleQuote" = true;
        "prettier.trailingComma" = "all";
        "cSpell.userWords" = [
          "autoresize"
          "commenters"
          "echarts"
          "favourites"
          "Yari"
        ];
        "chat.commandCenter.enabled" = false;
        "javascript.updateImportsOnFileMove.enabled" = "always";
        "editor.defaultFormatter" = "esbenp.prettier-vscode";

        "files.associations" = {
          "*.md" = "markdown";
        };
        "markdown.preview.openMarkdownLinks" = "inPreview";
        "workbench.editorAssociations" = {
          "*.copilotmd" = "vscode.markdown.preview.editor";
          "*.md" = "markdown.preview.editor";
          "*.db" = "default";
        };
        "typescript.updateImportsOnFileMove.enabled" = "always";
        "svg.preview.mode" = "svg";
        "command-runner.terminal.name" = "runCommand";
        "command-runner.terminal.autoClear" = true;
        "command-runner.commands" = {
          "elixirFormat" = "mix format && exit";
        };
        "editor.formatOnPaste" = true;
        "[c]" = {
          "editor.defaultFormatter" = "ms-vscode.cpptools";
        };
        "workbench.iconTheme" = "material-icon-theme";
        "diffEditor.ignoreTrimWhitespace" = false;
        "editor.largeFileOptimizations" = false;
        "github.copilot.enable" = {
          "*" = true;
          "plaintext" = false;
          "markdown" = false;
          "scminput" = false;
          "c" = true;
        };
        "workbench.editor.empty.hint" = "hidden";
        "github.copilot.nextEditSuggestions.enabled" = true;
        "editor.unicodeHighlight.invisibleCharacters" = false;
        "explorer.confirmDragAndDrop" = false;
        "window.customTitleBarVisibility" = "never";

        "vim.active" = false;

        "extensions.autoUpdate" = false;
        "extensions.autoCheckUpdates" = true;
      };

      # --------------------------------------------------------
      # KEYBINDINGS
      # --------------------------------------------------------
      keybindings = [
        {
          key = "ctrl+shift+m";
          command = "markdown.showPreview";
          when = "editorLangId == markdown";
        }
        {
          key = "ctrl+alt+s";
          command = "command-runner.run";
          when = "editorTextFocus";
        }
        {
          key = "ctrl+shift+s";
          command = "command-runner.run";
          args = {
            command = "elixirFormat";
          };
        }
      ];
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
