{ pkgs, my, ... }:

{
  users.users.${my.username} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "lp"
      "libvirtd"
      "wireshark"
      "docker"
    ];
    ignoreShellProgramCheck = true;
  };

  nix.settings.trusted-users = [
    "root"
    my.username
  ];

  programs.zsh.enable = true;
}
