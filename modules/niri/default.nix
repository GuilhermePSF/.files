{ pkgs, lib, config, ... }:

let
  terminal = "ghostty";
  browser = "brave";
  
  cursorName = "Bibata-Modern-Classic";
  cursorSize = 24;

  # Colors
  c_focus = "#33ccffee";
  c_inactive = "#595959aa";

  # --- Workspace Binds Generation ---
  workspaces = builtins.genList (x: x + 1) 10;
  binds_workspaces = builtins.concatStringsSep "\n        " (map (i: ''
    Mod+${toString (if i == 10 then 0 else i)} { focus-workspace ${toString i}; }
    Mod+Shift+${toString (if i == 10 then 0 else i)} { move-column-to-workspace ${toString i}; }
  '') workspaces);

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
      # cursorPackage # Removed to avoid conflict, let Hyprland or Home handle this
    ];

    # --- REMOVED CONFLICTING BLOCK ---
    # Since Hyprland is enabled, it sets this. 
    # If you ever disable Hyprland, move this block to your home.nix.
    # home.pointerCursor = {
    #   gtk.enable = true;
    #   x11.enable = true;
    #   name = cursorName;
    #   package = pkgs.bibata-cursors;
    #   size = cursorSize;
    # };

    # --- Niri Configuration ---
    xdg.configFile."niri/config.kdl".text = ''
      input {
        keyboard { xkb { layout "us"; } }
        touchpad { tap; natural-scroll; dwt; }
        focus-follows-mouse
      }

      output "1" { scale 1.0; }

      layout {
        gaps 8
        struts { left 4; right 4; top 4; bottom 4; }
        center-focused-column "never"
        border {
          enable
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

      spawn-at-startup "xwayland-satellite"
      spawn-at-startup "noctalia-shell"

      window-rule {
        match title="^(Open File)$"
        match title="^(Select a File)$"
        match title="^(Choose wallpaper)$"
        match title="^(Open Folder)$"
        match title="^(Save As)$"
        match title="^(Library)$"
        match title="^(File Operation Progress)$"
        match title="^(Picture-in-Picture)$"
        open-floating true
      }

      binds {
        Mod+Q { close-window; }
        Mod+Shift+Q { quit; }
        Mod+F { fullscreen-window; }
        Mod+V { switch-preset-column-width; }
        Mod+Space { spawn "noctalia-shell" "ipc" "call" "launcher" "toggle"; }

        Mod+Return { spawn "${terminal}"; }
        Mod+B { spawn "${browser}"; }
        Mod+D { spawn "rofi" "-show" "drun"; }

        Mod+Shift+S { spawn "sh" "-c" "${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"; }

        Mod+H { focus-column-left; }
        Mod+L { focus-column-right; }
        Mod+K { focus-window-up; }
        Mod+J { focus-window-down; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+L { move-column-right; }

        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "s" "10%+"; }
        XF86MonBrightnessDown { spawn "${pkgs.brightnessctl}/bin/brightnessctl" "s" "10%-"; }

        ${binds_workspaces}
      }
    '';
  };
}