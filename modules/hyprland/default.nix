{ pkgs, lib, config, ... }:

let
  terminal = "ghostty";
  browser = "brave";
  
  wallpaperFile = "${config.home.homeDirectory}/.background-image";

  ### CURSOR POINTER CONFIGURATION ###
  cursorName = "Bibata-Modern-Classic";
  cursorPackage = pkgs.bibata-cursors;
  cursorSize = 24;

  # Standard Hex/RGBA
  c_focus = "rgba(33ccffee)";
  c_inactive = "rgba(595959aa)";

  # Wraps the command in Hyprland's exec syntax
  noctalia = action: cmd: "noctalia-shell ipc call \"${action}\" \"${cmd}\"";
in 
{
  options.hyprlandModule.enable = lib.mkEnableOption "Enable Hyprland Module";

  config = lib.mkIf config.hyprlandModule.enable {
    
    home.packages = with pkgs; [
      brightnessctl 
      hyprpaper
      hyprshot
      grim
      slurp
      swappy
      cliphist
      wl-clipboard
      gpu-screen-recorder
      wofi
      cursorPackage
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true; 
      name = cursorName;
      package = cursorPackage;
      size = cursorSize;
    };

    xdg.configFile."hypr/display-mode.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        # WIN+P style display mode picker
        LAPTOP="eDP-1"
        EXTERNAL=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name' | grep -v "$LAPTOP" | head -1)

        CHOICE=$(printf 'laptop-only\nexternal-only\nmirror\nextend-vertical (laptop bottom)\nextend-vertical (laptop top)' \
          | wofi --dmenu --prompt "Display mode" --width 400 --height 220)

        case "$CHOICE" in
          "laptop-only")
            hyprctl keyword monitor "$LAPTOP,preferred,0x0,1"
            [ -n "$EXTERNAL" ] && hyprctl keyword monitor "$EXTERNAL,disabled"
            ;;
          "external-only")
            [ -n "$EXTERNAL" ] && hyprctl keyword monitor "$EXTERNAL,preferred,0x0,1"
            hyprctl keyword monitor "$LAPTOP,disabled"
            ;;
          "mirror")
            hyprctl keyword monitor "$LAPTOP,preferred,0x0,1,mirror,$EXTERNAL"
            ;;
          "extend-vertical (laptop bottom)")
            [ -n "$EXTERNAL" ] && hyprctl keyword monitor "$EXTERNAL,preferred,0x0,1"
            hyprctl keyword monitor "$LAPTOP,preferred,0x1080,1"
            ;;
          "extend-vertical (laptop top)")
            hyprctl keyword monitor "$LAPTOP,preferred,0x0,1"
            [ -n "$EXTERNAL" ] && hyprctl keyword monitor "$EXTERNAL,preferred,0x1080,1"
            ;;
        esac
      '';
    };

    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ${wallpaperFile}
      wallpaper = ,${wallpaperFile}
      splash = false
    '';

    xdg.dataFile."icons/${cursorName}".source = "${cursorPackage}/share/icons/${cursorName}";

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland; 
      systemd.variables = ["--all"];

      settings = {
        "$mod" = "SUPER";

        # Default monitor layout: vertical alignment
        monitor = [
          "eDP-1,preferred,0x1080,1"     # laptop screen — bottom
          ",preferred,0x0,1"              # any other monitor — on top
        ];

        env = [
          "XCURSOR_THEME,${cursorName}"
          "XCURSOR_SIZE,${toString cursorSize}"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
        ];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = c_focus;
          "col.inactive_border" = c_inactive;
          layout = "dwindle";
          resize_on_border = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 2;
          touchpad = {
            natural_scroll = true;
            tap-to-click = true;
          };
        };
  
        decoration = {
          rounding = 6;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
        };

        animations = {
          enabled = true;
          bezier = "decel, 0.05, 0.9, 0.1, 1.0";
          animation = [
            "windows, 1, 3, decel, popin 80%"
            "windowsOut, 1, 3, decel, popin 80%" 
            "border, 1, 5, default"
            "fade, 1, 3, default"
            "workspaces, 1, 4, decel, slide"
          ];
        };

        # Main Bindings
        bind = [
          "$mod, Q, killactive"
          "$mod SHIFT, Q, exit"
          "$mod, F, fullscreen"
          "$mod, V, togglefloating"
          
          # Apps & Shell (Noctalia integrated)
          "$mod, Return, exec, ${terminal}"
          "$mod, B, exec, ${browser}"
          "$mod, Space, exec, ${noctalia "launcher" "toggle"}"
          "$mod SHIFT, E, exec, ${noctalia "sessionMenu" "toggle"}"
          
          "$mod SHIFT, S, exec, hyprshot -m region"

          "$mod, P, exec, ~/.config/hypr/display-mode.sh"

          # Navigation (HJKL)
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"
          
          # Window Shifting
          "$mod SHIFT, H, movewindow, l"
          "$mod SHIFT, L, movewindow, r"
          "$mod SHIFT, K, movewindow, u"
          "$mod SHIFT, J, movewindow, d"

          # Media Controls (Noctalia)
          ", XF86AudioPlay, exec, ${noctalia "media" "playPause"}"
          ", XF86AudioNext, exec, ${noctalia "media" "next"}"
          ", XF86AudioPrev, exec, ${noctalia "media" "previous"}"
        ] 
        # Clean workspace generator to match Niri's logic
        ++ (map (i: "$mod, ${toString (if i == 10 then 0 else i)}, workspace, ${toString i}") (builtins.genList (x: x + 1) 10))
        ++ (map (i: "$mod SHIFT, ${toString (if i == 10 then 0 else i)}, movetoworkspace, ${toString i}") (builtins.genList (x: x + 1) 10));
        
        # Repeating Keys
        bindel = [
          # Audio (Noctalia)
          ", XF86AudioRaiseVolume, exec, ${noctalia "volume" "increase"}"
          ", XF86AudioLowerVolume, exec, ${noctalia "volume" "decrease"}"
          ", XF86AudioMute, exec, ${noctalia "volume" "muteOutput"}"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          
          # Brightness (Noctalia)
          ", XF86MonBrightnessUp, exec, ${noctalia "brightness" "increase"}"
          ", XF86MonBrightnessDown, exec, ${noctalia "brightness" "decrease"}"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        exec-once = [
          "hyprpaper"
          "hyprctl setcursor ${cursorName} ${toString cursorSize}"
          "wl-paste --type text --watch cliphist store" 
          "wl-paste --type image --watch cliphist store"
        ];
      };
    };
  };
}