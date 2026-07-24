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
      # 1. Stop WirePlumber from auto-switching profiles when a microphone is requested
      "11-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };

      # 2. Tell the BlueZ monitor to ONLY expose the high-quality playback roles
      "12-bluez-clean-profiles" = {
        "monitor.bluez.properties" = {
          "bluez5.roles" = [ "a2dp_sink" "a2dp_source" "bap_sink" "bap_source" ];
        };
      };

      "99-audio-priority" = {
        "monitor.bluez.rules" = [
          {
            matches = [
              { "node.name" = "~bluez_output.*"; }
            ];
            actions.update-props = {
              "priority.session" = 1500;
              "priority.driver" = 1500;
            };
          }
        ];
        
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
