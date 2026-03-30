{ lib, config, pkgs, ... }:

let
  toggleLaptopScreen = pkgs.writeShellScriptBin "toggle-laptop-screen" ''
    LAPTOP="eDP-1"
    JQ="${pkgs.jq}/bin/jq"

    DISABLED=$(hyprctl monitors all -j | $JQ -r \
      --arg name "$LAPTOP" \
      '.[] | select(.name==$name) | .disabled')

    if [ "$DISABLED" = "true" ]; then
      # Find the currently active external monitor
      EXTERNAL=$(hyprctl monitors -j | $JQ -r \
        '.[] | select(.name!="eDP-1") | .name' | head -1)

      if [ -n "$EXTERNAL" ]; then
        # Compute logical bottom edge of external (height divided by scale)
        # This works correctly regardless of the external monitor's resolution or scale
        EXT_BOTTOM=$(hyprctl monitors -j | $JQ -r \
          --arg name "$EXTERNAL" \
          '.[] | select(.name==$name) | (.y + (.height / .scale)) | floor')
        hyprctl keyword monitor "$LAPTOP,1920x1200@60,0x${EXT_BOTTOM},1"
      else
        # No external found — re-enable at origin
        hyprctl keyword monitor "$LAPTOP,1920x1200@60,0x0,1"
      fi
    else
      hyprctl keyword monitor "$LAPTOP,disable"
    fi
  '';
in
{
  options.kanshiModule.enable = lib.mkEnableOption "Enable Kanshi display management module";

  config = lib.mkIf config.kanshiModule.enable {

    services.kanshi = {
      enable = true;
      settings = [

        # ── Undocked: laptop screen only ──────────────────────────────────
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "Chimei Innolux Corporation 0x143F";
              status = "enable";
              mode = "1920x1200@60Hz";
              position = "0,0";
              scale = 1.0;
            }
          ];
        }

        # ── Docked: Gigabyte G27Q above, laptop below ─────────────────────
        # auto-down positions the laptop relative to whatever the external
        # monitor's actual resolution/scale ends up being — no hardcoded offsets.
        {
          profile.name = "docked-both";
          profile.outputs = [
            {
              # Matched by serial for reliability across reboots/replugs.
              # To add a new external monitor: duplicate this profile block and
              # change criteria to the new monitor's description string from:
              #   hyprctl monitors -j | jq '.[].description'
              criteria = "GIGA-BYTE TECHNOLOGY CO., LTD. G27Q 21022B000223";
              status = "enable";
              mode = "2560x1440@60Hz";
              position = "0,0";
              scale = 1.0;
            }
            {
              criteria = "Chimei Innolux Corporation 0x143F";
              status = "enable";
              mode = "1920x1200@60Hz";
              position = "auto-down";
              scale = 1.0;
            }
          ];
        }

      ];
    };

    home.packages = [ toggleLaptopScreen ];
  };
}
