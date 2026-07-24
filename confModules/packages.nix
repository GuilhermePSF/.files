{ pkgs, my, ... }:

{
  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    dev.enable = true;
  };

  environment.systemPackages = with pkgs; [
    typst
    wget
    git
    tree
    btop
    ngrok
    wl-clipboard
    bluez
    bluez-tools
    nixfmt
    gemini-cli
    alacritty
    man-pages
    man-pages-posix
    usbutils
    glib
    glib.dev
    pkg-config
    exercism
    hyperfine
    qbittorrent

    opencode

    eduvpn-client

    poppler-utils
  ];

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc.lib
    zlib
    openssl
  ];

  services.flatpak.enable = true;

  environment.variables = {
    NH_FLAKE = my.nixosConfig;
    TERMINAL = "ghostty";
    NIXOS_OZONE_WL = "1";
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-generations +5";
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
