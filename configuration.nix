{ config, lib, pkgs, ... }:

{
  imports = [
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

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.displayManager.sessionPackages = [ pkgs.niri ];

  hardware.graphics.enable = true; 

  hardware.bluetooth.enable = true;       # Needed for Bluetooth widget
  hardware.bluetooth.powerOnBoot = true;  # Optional: powers up bluetooth on boot
  services.upower.enable = true;          # Needed for Battery widget
  services.power-profiles-daemon.enable = true; # Needed for Power Profile widget

  # Display Manager
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

  programs.zsh.enable = true;

  programs.ssh.startAgent = true;

  environment.variables = {
    NH_FLAKE = "/home/gui/nixos-config";
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

    kdePackages.dolphin
    vesktop

    nh
    nix-output-monitor
    nvd

    wl-clipboard
    hyprpaper
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
  ];

  nix.gc = {
    automatic = true;
    dates = "daily"; 
    options = "--delete-generations +5";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";
}
