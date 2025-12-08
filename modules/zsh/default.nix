{ pkgs, lib, config, ... }:

let 
  aliases = import ./aliases.nix;
in
{
  options.zshModule.enable = lib.mkEnableOption "Enable Zsh Module";

     config = lib.mkIf config.zshModule.enable {
	  home.packages = with pkgs; [
	    # --- System Tools ---
	    eza             # Better ls
	    chafa           # Image viewer
	    gdu             # Disk usage
	    ripgrep         # Better grep
	    fd              # Better find

	    # --- Dev Tools (Global) ---
	    git
	    nodejs_22       # Replaces nvm
	    bun             # Replaces bun installer
	    go              # Replaces manual go install
	    rustc           # Replaces ~/.cargo/env
	    cargo           # Replaces ~/.cargo/env
	    pnpm            # Replaces npm install -g pnpm
	    yarn            # Replaces npm install -g yarn
	    
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
	      
	      ERL_AFLAGS = "-kernel shell_history enabled -kernel shell_history_file_bytes 4096000";
	      # Note: No need for PATH hacks anymore; Nix handles PATH automatically!
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
	      # Fastfetch is still WIP
	      fastfetch

	      # --- Custom Bash/Zsh Functions ---
	      # These are valid shell syntax, so we keep them here.
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
	    options = [ "--cmd cd" ]; # Replaces cd with z
	  };
	  # MAGIC REPLACEMENT FOR NVM/ASDF ,still trying to understand...
	  programs.direnv = {
	    enable = true;
	    enableZshIntegration = true;
	    nix-direnv.enable = true;
	  };
      };
}
