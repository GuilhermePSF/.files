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

    home.packages = with pkgs; [
      # --- System Tools ---
      eza # Better ls
      chafa # Image viewer
      gdu # Disk usage
      ripgrep # Better grep
      fd # Better find
      bat # Better cat
      fzf # Fuzzy finder
      zoxide # Smarter cd
      wl-clipboard # Wayland clipboard tool

      # --- Dependencies for your specific Aliases ---
      xrandr

      # --- Dev Tools ---
      go # Go
      pnpm # JS Package Manager

      # --- Nix Tools ---
      direnv
      nix-direnv

      # --- Compilers ---
      gcc
      gnumake
    ];

    programs.zsh = {
      enable = true;
      dotDir = ".config/nvim";
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
        BROWSER = "brave";

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

        # Ensure ~/.local/bin (uv tool installs) is always in PATH
        export PATH="$HOME/.local/bin:$PATH"

        eval "$(direnv hook zsh)"

        # --- Custom Functions ---
        ce() { cd "$@" && code . && exit; }
        co() { cd "$@" && nautilus . > /dev/null 2>&1 & disown; }
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
