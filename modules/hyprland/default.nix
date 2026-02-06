{ pkgs, lib, config, ... }:

let
  terminal = "ghostty";
  browser = "brave";
  launcher = "rofi -show drun";
  
  wallpaperFile = "${config.home.homeDirectory}/.background-image";

  ### CURSOR POINTER CONFIGURATION ###
  cursorName = "Bibata-Modern-Classic";
  cursorPackage = pkgs.bibata-cursors;
  cursorSize = 24;

  # Standard Hex/RGBA for 2026 Hyprland
  c_focus = "rgba(33ccffee)";
  c_inactive = "rgba(595959aa)";
in 
{
  options.hyprlandModule.enable = lib.mkEnableOption "Enable Hyprland Module";

  config = lib.mkIf config.hyprlandModule.enable {
    
    home.packages = with pkgs; [
      brightnessctl 
      hyprpaper
      grim
      slurp
      swappy
      cursorPackage
    ];

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true; 
      name = cursorName;
      package = cursorPackage;
      size = cursorSize;
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

        # Modern Monitor Syntax
        monitor = ",preferred,auto,1";

        # Updated Env Syntax (Key,Value)
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
          # Reduced flickering on window resize
          resize_on_border = true;
        };

        input = {
          kb_layout = "us";
          follow_mouse = 2; # Focus on click/manually, better for multi-window
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

        # Cleaned up Keybindings
        bind = [
          "$mod, Q, killactive"
          "$mod SHIFT, Q, exit"
          "$mod, F, fullscreen"
          "$mod, V, togglefloating"
          
          # App Launches
          "$mod, Space, exec, ${launcher}"
          "$mod, Return, exec, ${terminal}"
          "$mod, B, exec, ${browser}"
          
          # Screenshots (Grim + Slurp + Swappy)
          "$mod SHIFT, S, exec, grim -g \"$(slurp)\" - | swappy -f -"

          # Focus Movement (Vim keys)
          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          # Workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 0"


          # Move to Workspace
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 0"

        ];
        
        # Repeating Keys (Volume/Brightness)
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          
          ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        ];

        # Mouse Bindings
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        # Startup
        exec-once = [
          "hyprpaper"
          "hyprctl setcursor ${cursorName} ${toString cursorSize}"
          "noctalia-shell"
        ];
      };
    };
  };
}
