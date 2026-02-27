{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # --- SYSTEM CORE ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-btw";
  networking.networkmanager.enable = true;
  networking.resolvconf.enable = false;

  time.timeZone = "Europe/Lisbon";

  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    domains = [ "~." ];
  };

  # --- GRAPHICS & DESKTOP ---
  hardware.graphics.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.displayManager.sessionPackages = [ pkgs.niri ];
  services.displayManager.ly.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # --- VIRTUALIZATION (KVM/QEMU) ---
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.dconf.enable = true;

  # --- WIRESHARK ---
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # --- AUDIO & HARDWARE ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # --- USER CONFIG ---
  users.users.gui = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "lp"
      "libvirtd"
      "wireshark"
    ];
    ignoreShellProgramCheck = true;
  };

  nix.settings.trusted-users = [
    "root"
    "gui"
  ];

  # --- PROGRAMS ---
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  environment.variables = {
    NH_FLAKE = "/home/gui/nixos-config";
    TERMINAL = "ghostty";
    NIXOS_OZONE_WL = "1";
  };

  # --- MOUNTS ---
  fileSystems."/mnt/PopOSPartition" = {
    device = "/dev/disk/by-uuid/4674f222-87f4-46a1-8b0e-18796c5faccf";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/gui/popOSHome" = {
    device = "/mnt/PopOSPartition/home/gui";
    fsType = "none";
    options = [ "bind" ];
    depends = [ "/mnt/PopOSPartition" ];
  };

  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [

    # System Utils
    wget
    git
    tree
    wl-clipboard
    hyprpaper
    bluez
    bluez-tools
    nixfmt

    # Browsers
    brave
    firefox

    # Tools
    vim
    neovim
    zsh-powerlevel10k
    slack
    jetbrains.datagrip
    gemini-cli
    kdePackages.dolphin
    krita
    vesktop

    qemu_kvm
  ];

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    dejavu_fonts
  ];

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-generations +5";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}
