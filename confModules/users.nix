{ pkgs, config, ... }:

{
  users.users.${config.username} = {
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
    config.username
  ];

  programs.zsh.enable = true;
}
