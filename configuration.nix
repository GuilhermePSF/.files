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
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gnome  # keeps GTK file pickers working
    ];
    config.common.default = "*";
  };

  # --- VIRTUALIZATION ---
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.dconf.enable = true;

  # --- WIRESHARK ---
  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  # --- AUDIO ---
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

  # --- USER ---
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

  nix.settings.trusted-users = [ "root" "gui" ];

  programs.zsh.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  environment.variables = {
    NH_FLAKE    = "/home/gui/nixos-config";
    TERMINAL    = "ghostty";
    NIXOS_OZONE_WL = "1";
  };

  # --- MOUNTS ---
  fileSystems."/mnt/PopOSPartition" = {
    device  = "/dev/disk/by-uuid/4674f222-87f4-46a1-8b0e-18796c5faccf";
    fsType  = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/gui/popOSHome" = {
    device  = "/mnt/PopOSPartition/home/gui";
    fsType  = "none";
    options = [ "bind" ];
    depends = [ "/mnt/PopOSPartition" ];
  };

  # --- PACKAGES ---
  environment.systemPackages = with pkgs; [
    wget
    git
    tree
    wl-clipboard
    hyprpaper
    bluez
    bluez-tools
    nixfmt
    vim
    neovim
    zsh-powerlevel10k
    slack
    jetbrains.datagrip
    gemini-cli
    krita
    vesktop
    qemu_kvm
  ];

  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates     = "daily";
    options   = "--delete-generations +5";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ----------------------------------------------------------------
  # STYLIX — overrides EVERYTHING system-wide
  # Per-app opt-outs are handled inside each module (vscode only)
  # ----------------------------------------------------------------
  stylix = {
    enable     = true;
    autoEnable = true;          # touches every target by default

    # Local wallpaper from the repo
    image = ./wallpaper.jpg;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";

    cursor = {
      package = pkgs.bibata-cursors;
      name    = "Bibata-Modern-Classic";
      size    = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name    = "FiraCode Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name    = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name    = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name    = "Noto Color Emoji";
      };
    };

    # System-level targets only — home-manager targets live in their own modules
    targets = {
      gtk.enable      = true;
      qt.enable       = true;
      plymouth.enable = true;
      grub.enable     = false; # using systemd-boot
      console.enable  = true;
    };
  };

  system.stateVersion = "25.11";
}
