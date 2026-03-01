{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    wget
    git
    tree
    wl-clipboard
    hyprpaper
    bluez
    bluez-tools
    nixfmt
    gemini-cli
    qemu_kvm
  ];

  nixpkgs.config.allowUnfree = true;

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
