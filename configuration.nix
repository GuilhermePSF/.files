{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Lisbon";

  programs.hyprland = {
    enable = true;
    # withUWSM = true;
    xwayland.enable = true; # Allow X11 apps to run
  };

  hardware.graphics.enable = true; 

  # ### DISPLAY MANAGER ###
  services.displayManager.ly.enable = true;


  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # jack.enable = true;
  };

  users.users.gui = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    ignoreShellProgramCheck = true;
  };

  # Defines zsh as a known shell so users.users.gui.shell works
  programs.zsh.enable = true; 

  environment.variables = {
    NH_FLAKE = "/etc/nixos";
    TERMINAL = "ghostty";
    # Hint for electron apps to use Wayland
    NIXOS_OZONE_WL = "1"; 
  };

  environment.systemPackages = with pkgs; [
    vim
    neovim
    wget
    brave
    git
    zsh-powerlevel10k
    tree

    nh # Nix Help and its "dependencies"
    nix-output-monitor
    nvd

    waybar       # Status bar (from your reference)
    rofi-wayland # App launcher (dmenu/rofi alternative for Wayland)
    dunst        # Notification daemon
    wl-clipboard # Copy/paste functionality in Wayland
    hyprpaper    # Wallpaper utility
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.packages = with pkgs; [
  	nerd-fonts.fira-code
	nerd-fonts.symbols-only
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.05";
}
