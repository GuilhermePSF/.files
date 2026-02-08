{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
  };

  networking.resolvconf.enable = false;

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

  services.postgresql = {
  enable = true;
  package = pkgs.postgresql_16;
  ensureDatabases = [ "pearl_dev" ];
  authentication = pkgs.lib.mkOverride 10 ''
    host all all 127.0.0.1/32 trust
  '';
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

  nix.settings.trusted-users = [ "root" "gui" ];

  programs.zsh.enable = true;

  environment.variables = {
    NH_FLAKE = "/home/gui/nixos-config";
    TERMINAL = "ghostty";
    # Hint for electron apps to use Wayland
    NIXOS_OZONE_WL = "1"; 
  };

  fileSystems."/mnt/PopOSPartition" = {
    device = "/dev/disk/by-uuid/4674f222-87f4-46a1-8b0e-18796c5faccf";
    fsType = "ext4"; 
    # 'nofail' ensures boot even if the partition is deleted
    options = [ "nofail" ]; 
  };

  fileSystems."/home/gui/popOSHome" = {
    device = "/mnt/PopOSPartition/home/gui"; 
    
    fsType = "none";
    options = [ "bind" ];
    
    depends = [ "/mnt/PopOSPartition" ]; 
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
