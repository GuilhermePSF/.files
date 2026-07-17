{ ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    wireplumber.extraConfig = {
      "99-audio-priority" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_output.*HiFi__HDMI.*__sink"; }
              { "node.name" = "~alsa_output.*HiFi__DP.*__sink"; }
            ];
            actions.update-props = {
              "priority.session" = 600;
              "priority.driver" = 600;
            };
          }
          {
            matches = [
              { "node.name" = "~alsa_output.*HiFi__Headphones.*__sink"; }
              { "node.name" = "~alsa_output.*HiFi__Headphone.*__sink"; }
            ];
            actions.update-props = {
              "priority.session" = 1200;
              "priority.driver" = 1200;
            };
          }
        ];
      };
    };
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
