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
  toast =
    title: body: icon:
    "noctalia-shell ipc call toast send '{\"title\":\"${title}\",\"body\":\"${body}\",\"icon\":\"${icon}\",\"duration\":1500}'";
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
      nwg-displays
    ];

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

        monitor = [
          # External monitor: always at origin, preferred mode
          ",preferred,0x0,1"
          # Laptop: always below whatever external is present, auto-positioned
          "eDP-1,1920x1200@60,auto-down,1"
        ];

        env = [
          "XCURSOR_THEME,${cursorName}"
          "XCURSOR_SIZE,${toString cursorSize}"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
        ];

        general = {
          gaps_in = 1;
          gaps_out = 3;
          border_size = 2;
          layout = "master";
          resize_on_border = true;
        };

        master = {
          orientation = "left";
          new_status = "slave";
        };

        misc = {
          focus_on_activate = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            tap-to-click = true;
            disable_while_typing = false;
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

        bind = [
          "$mod, Q, killactive"
          "$mod SHIFT, Q, exit"
          "$mod, F, fullscreen"
          "$mod, V, togglefloating"
          "$mod, T, exec, hyprctl dispatch layoutmsg orientationcycle left top && ${
            toast "Tiling" "Layout orientation toggled" "media-record"
          }"

          # Apps & Shell (Noctalia integrated)
          "$mod, Return, exec, ${terminal}"
          "$mod, B, exec, ${browser}"
          "$mod, E, exec, nautilus"
          "$mod, Space, exec, ${noctalia "launcher" "toggle"}"
          "$mod SHIFT, E, exec, ${noctalia "sessionMenu" "toggle"}"
          "$mod CTRL, L, exec, ${noctalia "lockScreen" "lock"}"

          "$mod SHIFT, S, exec, hyprshot -m region"

          "$mod SHIFT, N, exec, busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 0.3"
          "$mod SHIFT, M, exec, busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1.0"

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
        ++ (map (i: "$mod, ${toString (if i == 10 then 0 else i)}, workspace, ${toString i}") (
          builtins.genList (x: x + 1) 10
        ))
        ++ (map (i: "$mod SHIFT, ${toString (if i == 10 then 0 else i)}, movetoworkspace, ${toString i}") (
          builtins.genList (x: x + 1) 10
        ));

        bindel = [
          ", XF86AudioRaiseVolume, exec, ${noctalia "volume" "increase"}"
          ", XF86AudioLowerVolume, exec, ${noctalia "volume" "decrease"}"
          ", XF86AudioMute, exec, ${noctalia "volume" "muteOutput"}"
          ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

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
          "hyprctl setcursor ${cursorName} ${toString cursorSize}"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "noctalia-shell"
        ];
      };
    };
  };
}
