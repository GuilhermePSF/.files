{ pkgs, lib, config, ... }:

let
  terminal = "ghostty";
  browser = "brave";
  cursorName = "Bibata-Modern-Classic";
  cursorSize = 24;
  c_focus = "#33ccffee";
  c_inactive = "#595959aa";

  workspaces = builtins.genList (x: x + 1) 10;
  binds_workspaces = builtins.concatStringsSep "\n        " (map (i: ''
    Mod+${toString (if i == 10 then 0 else i)} { focus-workspace ${toString i}; }
    Mod+Shift+${toString (if i == 10 then 0 else i)} { move-column-to-workspace ${toString i}; }
  '') workspaces);

  noctalia = action: cmd: "spawn \"noctalia-shell\" \"ipc\" \"call\" \"" + action + "\" \"" + cmd + "\";";
in 
{
  options.niriModule.enable = lib.mkEnableOption "Enable Niri Module";

  config = lib.mkIf config.niriModule.enable {

    home.packages = with pkgs; [
      brightnessctl
      grim
      slurp
      swappy
      xwayland-satellite
      cliphist 
      wl-clipboard
    ];

    xdg.configFile."niri/config.kdl".text = ''
      input {
        keyboard { xkb { layout "us"; }; }
        touchpad { tap; natural-scroll; dwt; }
        focus-follows-mouse
      }
      output "1" { scale 1.0; }
      layout {
        gaps 8
        struts { left 4; right 4; top 4; bottom 4; }
        center-focused-column "never"
        border {
          width 2
          active-color "${c_focus}"
          inactive-color "${c_inactive}"
        }
        focus-ring { off; } 
      }
      environment {
        DISPLAY ":0"
        XCURSOR_THEME "${cursorName}"
        XCURSOR_SIZE "${toString cursorSize}"
      }

      spawn-at-startup "xwayland-satellite";

      binds {
        Mod+Q { close-window; }
        Mod+Shift+Q { quit; }
        Mod+F { fullscreen-window; }
        Mod+V { switch-preset-column-width; }
        
        Mod+Return { spawn "${terminal}"; }
        Mod+B { spawn "${browser}"; }

        // Launcher
        Mod+Space { ${noctalia "launcher" "toggle"} }

        // Power Menu
        Mod+Shift+E { ${noctalia "sessionMenu" "toggle"} }

        // --- AUDIO CONTROLS (Fixed) ---
        // Note: We use "volume" directly, not "audio volume"
        XF86AudioRaiseVolume { ${noctalia "volume" "increase"} }
        XF86AudioLowerVolume { ${noctalia "volume" "decrease"} }
        
        // Mute Output (Speakers)
        XF86AudioMute        { ${noctalia "volume" "muteOutput"} }
        
        // Mute Input (Microphone) - Using wpctl for reliability as fallback
        XF86AudioMicMute     { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"; }

        // --- BRIGHTNESS CONTROLS ---
        XF86MonBrightnessUp   { ${noctalia "brightness" "increase"} }
        XF86MonBrightnessDown { ${noctalia "brightness" "decrease"} }

        // Media Keys
        XF86AudioPlay { ${noctalia "media" "playPause"} }
        XF86AudioNext { ${noctalia "media" "next"} }
        XF86AudioPrev { ${noctalia "media" "previous"} }

        // Standard Window Management
        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }
        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }
        
        Mod+Shift+S { spawn "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"; }

        ${binds_workspaces}
      }
    '';
  };
}