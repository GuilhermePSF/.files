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
      x11.enable = true; # ENABLED for XWayland compatibility
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

        monitor = ",preferred,auto,1";

	env = [
  "XCURSOR_THEME=${cursorName}"
  "XCURSOR_SIZE=${toString cursorSize}"
];

        general = {
          gaps_in = 4;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = c_focus;
          "col.inactive_border" = c_inactive;
          layout = "dwindle";
        };

	input = {
  kb_layout = "us";
  follow_mouse = 2;

  touchpad = {
    natural_scroll = true;
    disable_while_typing = true;
    tap_to_click = true;
  };
};
	
        decoration = {
          rounding = 6;
          
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
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

        windowrulev2 = [
          "float, title:^(Open File)$"
          "float, title:^(Select a File)$"
          "float, title:^(Choose wallpaper)$"
          "float, title:^(Open Folder)$"
          "float, title:^(Save As)$"
          "float, title:^(Library)$" 
          "float, title:^(File Operation Progress)$"

          "float, title:^(Picture-in-Picture)$"
          "pin, title:^(Picture-in-Picture)$"
          "move 100%-w-20 100%-h-20, title:^(Picture-in-Picture)$"
        ];

        bind = [
          "$mod, Q, killactive"
          "$mod SHIFT, Q, exit"
          "$mod, F, fullscreen"
          "$mod, V, togglefloating"
          "$mod, SPACE, exec, noctalia-shell ipc call launcher toggle"

          "$mod, Return, exec, ${terminal}"
          "$mod, B, exec, ${browser}"
          "$mod, Space, exec, ${launcher}"
          "$mod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.swappy}/bin/swappy -f -"

          "$mod, H, movefocus, l"
          "$mod, L, movefocus, r"
          "$mod, K, movefocus, u"
          "$mod, J, movefocus, d"

          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"

          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
        ];
        
        bindel = [
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          
          ",XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%+"
          ",XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl s 10%-"
        ];

        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        exec-once = [
          "${pkgs.hyprpaper}/bin/hyprpaper"
	  "hyprctl setcursor ${cursorName} ${toString cursorSize}"
	  "noctalia-shell"
        ];
      };
    };
  };
}
