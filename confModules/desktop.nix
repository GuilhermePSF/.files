{ pkgs, ... }:

{
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
      pkgs.xdg-desktop-portal-gnome # keeps GTK file pickers working
    ];
    config.common.default = "*";
  };

  programs.dconf.enable = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;
}
