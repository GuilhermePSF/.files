{
  pkgs,
  lib,
  config,
  ...
}:

let
  zedPackage = if builtins.hasAttr "zed-editor" pkgs then pkgs.zed-editor else pkgs.zed;

  zedSettings = {
    icon_theme = "Warm Charmed Icons";
    theme = "Aura Dark";
    theme_overrides = {
      "Aura Dark" = {
        "border.variant" = "#15141C";
        "border" = "#15141C";
        "title_bar.background" = "#15141C";
        "panel.background" = "#15141C";
        "panel.focused_border" = "#4E466E";
        "players" = [
          {
            "cursor" = "#BD9DFF";
          }
        ];
        "syntax" = {
          "comment" = {
            "font_style" = "italic";
          };
          "comment.doc" = {
            "font_style" = "italic";
          };
        };
      };
    };
    vim_mode = false;
    multi_cursor_modifier = "cmd_or_ctrl";
    cursor_shape = "block";
    cursor_blink = false;
    current_line_highlight = "none";
    show_whitespaces = "none";

    title_bar = {
      show_onboarding_banner = false;
      show_project_items = false;
      show_branch_name = false;
      show_user_menu = false;
    };
    tab_bar = {
      show = false;
    };
    toolbar = {
      quick_actions = false;
    };
    status_bar = {
      "experimental.show" = false;
    };
    project_panel = {
      dock = "right";
      default_width = 400;
      hide_root = true;
      auto_fold_dirs = false;
      starts_open = false;
      git_status = false;
      sticky_scroll = false;
      scrollbar = {
        show = "never";
      };
      indent_guides = {
        show = "never";
      };
    };
    outline_panel = {
      default_width = 300;
      indent_guides = {
        show = "never";
      };
    };
    file_finder = {
      modal_max_width = "large";
    };
    scrollbar = {
      show = "never";
    };
    gutter = {
      min_line_number_digits = 0;
      folds = false;
      runnables = false;
    };
    indent_guides = {
      enabled = false;
    };

    languages = {
      Nix = {
        language_servers = [
          "nixd"
          "!nil"
        ];
      };
    };

    ui_font_family = "Dank Mono";
    ui_font_size = 20;
    buffer_font_family = "Dank Mono";
    buffer_font_size = 20;
    buffer_line_height = {
      custom = 2;
    };
    agent_buffer_font_size = 20;
  };

  zedKeymap = [
    {

    }
  ];

  zedNixSnippets = {
    "Nix Shell (Zsh)" = {
      prefix = "nixzsh";
      body = [
        "{ pkgs ? import <nixpkgs> {} }:"
        ""
        "pkgs.mkShell {"
        "  nativeBuildInputs = with pkgs; ["
        "    $1"
        "  ];"
        ""
        "  shellHook = ''"
        "    exec zsh"
        "  '';"
        "}"
      ];
      description = "Create a nix shell that opens zsh directly";
    };
  };
in

{
  options.zedModule.enable = lib.mkEnableOption "Enable Zed module";

  config = lib.mkIf config.zedModule.enable {

    home.packages = with pkgs; [
      zedPackage
      nixd
    ];

    programs.zed-editor-extensions = {
      enable = true;
      packages = with pkgs.zed-extensions; [
        nix
        toml
        crates-lsp
        rust-snippets
        aura-theme
        charmed-icons
      ];
    };

    xdg.configFile."zed/settings.json".text = builtins.toJSON zedSettings;
    xdg.configFile."zed/keymap.json".text = builtins.toJSON zedKeymap;
    xdg.configFile."zed/snippets/nix.json".text = builtins.toJSON zedNixSnippets;
  };
}
