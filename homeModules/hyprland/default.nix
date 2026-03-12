{
  pkgs,
  lib,
  config,
  ...
}:

let
  terminal = "ghostty";
  browser = "brave";

  wallpaperFile = "${config.home.homeDirectory}/.background-image";

  ### CURSOR POINTER CONFIGURATION ###
  cursorName = "Bibata-Modern-Classic";
  cursorPackage = pkgs.bibata-cursors;
  cursorSize = 24;

  noctalia = action: cmd: "noctalia-shell ipc call \"${action}\" \"${cmd}\"";
  toast = title: body: icon: "noctalia-shell ipc call toast send '{\"title\":\"${title}\",\"body\":\"${body}\",\"icon\":\"${icon}\",\"duration\":1500}'";
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
      gpu-screen-recorder
      cursorPackage
      wl-gammarelay-rs
    ];

    # display-mode.sh — backend called by the Quickshell DisplayPicker with a single mode argument
    xdg.configFile."hypr/display-mode.sh" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        LAPTOP="eDP-1"
        EXTERNAL=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r '.[].name' | grep -v "$LAPTOP" | head -1)

        case "$1" in
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
          "extend-bottom")
            [ -n "$EXTERNAL" ] && hyprctl keyword monitor "$EXTERNAL,preferred,0x0,1"
            EXT_H=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r --arg name "$EXTERNAL" '.[] | select(.name==$name) | .height')
            EXT_H="''${EXT_H:-1080}"
            hyprctl keyword monitor "$LAPTOP,preferred,0x''${EXT_H},1"
            ;;
          "extend-top")
            hyprctl keyword monitor "$LAPTOP,preferred,0x0,1"
            LAPTOP_H=$(hyprctl monitors -j | ${pkgs.jq}/bin/jq -r --arg name "$LAPTOP" '.[] | select(.name==$name) | .height')
            LAPTOP_H="''${LAPTOP_H:-1080}"
            [ -n "$EXTERNAL" ] && hyprctl keyword monitor "$EXTERNAL,preferred,0x''${LAPTOP_H},1"
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
      systemd.variables = [ "--all" ];

      settings = {
        "$mod" = "SUPER";

        # Default monitor layout: laptop auto-positions below external
        # auto-down avoids overlap when external resolution != 1080p
        monitor = [
          ",preferred,0x0,1" # any external monitor — top, auto position
          "eDP-1,preferred,auto-down,1" # laptop screen — always below external
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
          gaps_out = 6;
          border_size = 3;
          layout = "master";
          resize_on_border = true;
        };

        master = {
          orientation = "left";
          new_status = "slave";
        };

        misc = {
          focus_on_activate = true; # switch workspace when an app requests focus (e.g. link opens browser)
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
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
          "$mod, T, exec, hyprctl dispatch layoutmsg orientationcycle left top && ${toast "Tiling" "Layout orientation toggled" "media-record"}"

          # Apps & Shell (Noctalia integrated)
          "$mod, Return, exec, ${terminal}"
          "$mod, B, exec, ${browser}"
          "$mod, E, exec, nautilus"
          "$mod, Space, exec, ${noctalia "launcher" "toggle"}"
          "$mod SHIFT, E, exec, ${noctalia "sessionMenu" "toggle"}"
          "$mod SHIFT, L, exec, ${noctalia "lockScreen" "lock"}"

          "$mod SHIFT, S, exec, hyprshot -m region"

          "$mod SHIFT, N, exec, busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 0.3"
          "$mod SHIFT, M, exec, busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1.0"

          "$mod, P, exec, qs ipc call displayPicker toggle"

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
        ++ (map (i: "$mod, ${toString (if i == 10 then 0 else i)}, workspace, ${toString i}") (
          builtins.genList (x: x + 1) 10
        ))
        ++ (map (i: "$mod SHIFT, ${toString (if i == 10 then 0 else i)}, movetoworkspace, ${toString i}") (
          builtins.genList (x: x + 1) 10
        ));

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

        # Lid switch — lock & suspend when closed
        bindl = [
          ", switch:on:Lid Switch, exec, ${noctalia "sessionMenu" "lockAndSuspend"}"
        ];

        exec-once = [
          "hyprpaper"
          "wl-gammarelay-rs run"
          # "qs"
          "hyprctl setcursor ${cursorName} ${toString cursorSize}"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
        ];
      };
    };
  };
}
