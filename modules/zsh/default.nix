{
  pkgs,
  lib,
  config,
  ...
}:

let
  aliases = import ./aliases.nix;
in
{
  options.zshModule.enable = lib.mkEnableOption "Enable Zsh Module";

  config = lib.mkIf config.zshModule.enable {

    # 1. Install the tools your aliases rely on
    home.packages = with pkgs; [
      # --- System Tools ---
      eza # Better ls
      chafa # Image viewer
      gdu # Disk usage
      ripgrep # Better grep
      fd # Better find
      bat # Better cat
      unzip # Zipping tool
      fzf # Fuzzy finder
      zoxide # Smarter cd
      xclip # Clipboard tool

      # --- Dependencies for your specific Aliases ---
      nautilus
      xrandr

      # --- Dev Tools ---
      git
      go # Go
      rustc # Rust Compiler
      cargo # Rust Package Manager
      pnpm # JS Package Manager

      direnv
      nix-direnv

      gcc
      gnumake
    ];

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      # Import the aliases file
      shellAliases = aliases.shellAliases;

      # Environment Variables
      sessionVariables = {
        LANG = "en_US.UTF-8";
        EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
        BROWSER = "firefox-developer-edition";

        # History Settings
        HISTFILESIZE = "100000000000";
        SAVEHIST = "5000000";
        HISTSIZE = "5000000";
        HIST_STAMPS = "dd-mm-yyyy";

        # Elixir History
        ERL_AFLAGS = "-kernel shell_history enabled -kernel shell_history_file_bytes 4096000";
      };

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "colored-man-pages"
          "command-not-found"
        ];
      };

      initContent = ''
        ${pkgs.fastfetch}/bin/fastfetch

        eval "$(direnv hook zsh)"

        # --- Custom Bash/Zsh Functions ---
        ce() { cd "$@" && code . && exit; }
        co() { cd "$@" && open . && exit; }
      '';
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd cd" ];
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
