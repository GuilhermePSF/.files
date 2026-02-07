{ pkgs, lib, config, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  options.noctaliaModule.enable = lib.mkEnableOption "Enable Noctalia Shell";

  config = lib.mkIf config.noctaliaModule.enable {
    
    # 1. Install necessary dependencies for plugins/clipboard
    home.packages = with pkgs; [ 
      cliphist 
      wl-clipboard 
    ];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true; 

      # 2. Configure Plugins
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          catwalk = { enabled = true; }; # Cool system monitor visualizer
        };
      };

      # 3. Main Configuration
      settings = {
        bar = {
          density = "compact"; # Keeps it tight
          position = "top";
          
          framed = true;
          marginVertical = 8;
          marginHorizontal = 8;
          backgroundOpacity = 0.8; # 80% Opacity
          showCapsule = true;      # The "island" look
          frameRadius = 16;        # Rounded corners for the bar itself

          widgets = {
            left = [
              { id = "ControlCenter"; useDistroLogo = true; }
              { id = "MediaMini"; }    # Music Controls
              { id = "Tray"; }         # System Tray
            ];
            center = [
              { 
                id = "Workspace"; 
                labelMode = "none";    # Just dots
                hideUnoccupied = false; 
              }
            ];
            right = [
              { id = "SystemMonitor"; } # CPU/RAM graphs
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "Battery"; warningThreshold = 30; }
              { 
                id = "Clock"; 
                formatHorizontal = "HH:mm"; 
                useMonospacedFont = true; 
                usePrimaryColor = true; 
              }
            ];
          };
        };

        # 4. Tokyo Night Theme & Colors
        colorSchemes = {
          predefinedScheme = "Tokyo Night";
          darkMode = true;
        };

        # 5. General Look & Feel
        general = {
          avatarImage = "${config.home.homeDirectory}/.face"; 
          radiusRatio = 1.0;          # "Really rounded" widgets 
          enableShadows = true;
          
          # Power Menu Configuration
          showSessionButtonsOnLockScreen = true;
        };

        # 6. Wallpaper Engine (Wallhaven)
        wallpaper = {
          enabled = true;
          useWallhaven = true;
          wallhavenQuery = "landscape";   # Search query
          wallhavenCategories = "111";    # General/Anime/People
          wallhavenPurity = "100";        # SFW only
          wallhavenSorting = "toplist";
          fillMode = "crop";
        };

        # 7. App Launcher & Clipboard
        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = false;
          # Ensure these commands match your installed packages
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        };
        
        # 8. OSD (Volume/Brightness Popups)
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
        };
      };
    };
  };
}