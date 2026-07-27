{
  pkgs,
  lib,
  config,
  ...
}:

let
  terminal = "ghostty";
  browser = "brave";
  mod = "SUPER";

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

    stylix.targets.hyprland.enable = false;

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

      configType = "lua";

      extraConfig = ''
        ------------------
        ---- MONITORS ----
        ------------------
        -- External monitor: always at origin, preferred mode
        hl.monitor({
          output = "",
          mode = "preferred",
          position = "0x0",
          scale = 1,
        })
        -- Laptop: always below whatever external is present, auto-positioned
        hl.monitor({
          output = "eDP-1",
          mode = "1920x1200@60",
          position = "auto-down",
          scale = 1,
        })

        -------------------------------
        ---- ENVIRONMENT VARIABLES ----
        -------------------------------
        hl.env("XCURSOR_THEME", "${cursorName}")
        hl.env("XCURSOR_SIZE", "${toString cursorSize}")
        hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
        hl.env("XDG_SESSION_TYPE", "wayland")
        hl.env("XDG_SESSION_DESKTOP", "Hyprland")

        -----------------------
        ---- LOOK AND FEEL ----
        -----------------------
        hl.config({
          general = {
            gaps_in = 1,
            gaps_out = 3,
            border_size = 2,
            layout = "master",
            resize_on_border = true,
          },
          master = {
            orientation = "left",
            new_status = "slave",
          },
          misc = {
            focus_on_activate = true,
          },
          input = {
            kb_layout = "us",
            follow_mouse = 1,
            touchpad = {
              natural_scroll = true,
              tap_to_click = true,
              disable_while_typing = false,
            },
          },
          decoration = {
            rounding = 6,
            shadow = {
              enabled = true,
              range = 4,
              render_power = 3,
            },
          },
          animations = {
            enabled = true,
          },
        })

        hl.curve("decel", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })

        hl.animation({ leaf = "windows",    enabled = true, speed = 3, bezier = "decel",  style = "popin 80%" })
        hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "decel",  style = "popin 80%" })
        hl.animation({ leaf = "border",     enabled = true, speed = 5, bezier = "default" })
        hl.animation({ leaf = "fade",       enabled = true, speed = 3, bezier = "default" })
        hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "decel",  style = "slide" })

        ---------------------
        ---- KEYBINDINGS ----
        ---------------------
        local mod = "${mod}"

        hl.bind(mod .. " + Q", hl.dsp.window.close())
        hl.bind(mod .. " + SHIFT + Q", hl.dsp.exit())
        hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
        hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
        hl.bind(mod .. " + T", hl.dsp.exec_cmd(
          [[hyprctl dispatch layoutmsg orientationcycle left top && ${
            toast "Tiling" "Layout orientation toggled" "media-record"
          }]]
        ))

        -- Apps & Shell (Noctalia integrated)
        hl.bind(mod .. " + Return", hl.dsp.exec_cmd("${terminal}"))
        hl.bind(mod .. " + B", hl.dsp.exec_cmd("${browser}"))
        hl.bind(mod .. " + E", hl.dsp.exec_cmd("nautilus"))
        hl.bind(mod .. " + Space", hl.dsp.exec_cmd([[${noctalia "launcher" "toggle"}]]))
        hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd([[${noctalia "sessionMenu" "toggle"}]]))
        hl.bind(mod .. " + CTRL + L", hl.dsp.exec_cmd([[${noctalia "lockScreen" "lock"}]]))

        hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region"))

        hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd(
          "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 0.3"
        ))
        hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd(
          "busctl --user set-property rs.wl-gammarelay / rs.wl.gammarelay Brightness d 1.0"
        ))

        -- Navigation (HJKL)
        hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
        hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))
        hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
        hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))

        -- Window Shifting
        -- NOTE: verify hl.dsp.window.move's direction form against
        -- https://wiki.hypr.land/Configuring/Basics/Binds/ and the
        -- Dispatchers page -- the Lua dispatcher surface is still new and
        -- some signatures may differ slightly from what's assumed here.
        hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
        hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
        hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
        hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

        -- Media Controls (Noctalia)
        hl.bind("XF86AudioPlay", hl.dsp.exec_cmd([[${noctalia "media" "playPause"}]]), { locked = true })
        hl.bind("XF86AudioNext", hl.dsp.exec_cmd([[${noctalia "media" "next"}]]), { locked = true })
        hl.bind("XF86AudioPrev", hl.dsp.exec_cmd([[${noctalia "media" "previous"}]]), { locked = true })

        -- Volume / brightness (repeating + locked, like the old bindel)
        hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd([[${noctalia "volume" "increase"}]]), { locked = true, repeating = true })
        hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd([[${noctalia "volume" "decrease"}]]), { locked = true, repeating = true })
        hl.bind("XF86AudioMute", hl.dsp.exec_cmd([[${noctalia "volume" "muteOutput"}]]), { locked = true, repeating = true })
        hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

        hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd([[${noctalia "brightness" "increase"}]]), { locked = true, repeating = true })
        hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd([[${noctalia "brightness" "decrease"}]]), { locked = true, repeating = true })

        -- Mouse move/resize
        hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
        hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

        -- Lid switch — lock & suspend when closed
        hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd([[${noctalia "sessionMenu" "lockAndSuspend"}]]), { locked = true })

        -- Workspaces: mod+[0-9] to switch, mod+SHIFT+[0-9] to move window
        for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
          hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
        end

        -------------------
        ---- AUTOSTART ----
        -------------------
        hl.on("hyprland.start", function()
          hl.exec_cmd("hyprpaper")
          hl.exec_cmd("wl-gammarelay-rs run")
          hl.exec_cmd("hyprctl setcursor ${cursorName} ${toString cursorSize}")
          hl.exec_cmd("wl-paste --type text --watch cliphist store")
          hl.exec_cmd("wl-paste --type image --watch cliphist store")
          hl.exec_cmd("noctalia-shell")
        end)
      '';
    };
  };
}
