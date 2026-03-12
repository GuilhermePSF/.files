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

  #services.fprintd = {
  #  enable = true;
  #  tod.enable = true;
  #  tod.driver = pkgs.libfprint-2-tod1-goodix;
  #};

  # security.pam.services = {
    # login.fprintAuth = true;
    # polkit-1.fprintAuth = true;
    # ly.fprintAuth = true;
  # };
# 
  # sudo: prompt for fingerprint AND password at the same time
  # security.pam.services.sudo.text = ''
    # auth sufficient pam_unix.so try_first_pass
    # auth sufficient pam_fprintd.so
    # auth required pam_deny.so
    # account required pam_unix.so
    # session required pam_unix.so
  # '';
}
