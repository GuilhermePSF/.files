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
  services.displayManager.gdm.enable = true;
  services.gnome.gnome-keyring.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    epiphany
    geary
    gedit
    gnome-characters
    gnome-console
    gnome-tour
    yelp
  ];

  services.desktopManager.gnome.enable = true;

  services.libinput.touchpad.disableWhileTyping = false;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gnome
    ];
    config.common.default = "*";
  };

  programs.dconf.enable = true;

  virtualisation.libvirtd.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.package = pkgs.docker_29;

  programs.virt-manager.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  security.polkit.enable = true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("net.reactivated.fprint.") == 0 &&
          subject.local && subject.active) {
        return polkit.Result.YES;
      }
    });
  '';

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  security.pam.services.sudo.text = ''
    auth sufficient pam_fprintd.so timeout=5
    auth sufficient pam_unix.so try_first_pass nullok
    auth required pam_deny.so
    account required pam_unix.so
    session required pam_unix.so
  '';
}
