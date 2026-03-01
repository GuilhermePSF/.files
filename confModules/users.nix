{ pkgs, ... }:

{
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

  programs.zsh.enable = true;
}
