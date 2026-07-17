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
      eza
      chafa
      gdu
      ripgrep
      fd
      bat
      fzf
      zoxide
      wl-clipboard
      xrandr
      go
      pnpm
      direnv
      nix-direnv
      gcc
      gnumake
    ];

    programs.zsh = {
      enable = true;
      dotDir = ".config/nvim";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = aliases.shellAliases;

      sessionVariables = {
        LANG = "en_US.UTF-8";
        EDITOR = "nvim";
        SUDO_EDITOR = "nvim";
        BROWSER = "brave";
        HISTFILESIZE = "100000000000";
        SAVEHIST = "5000000";
        HISTSIZE = "5000000";
        HIST_STAMPS = "dd-mm-yyyy";
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

        export PATH="$HOME/.local/bin:$PATH"

        eval "$(direnv hook zsh)"

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
