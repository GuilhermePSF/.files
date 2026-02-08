{ pkgs, lib, config, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  options.noctaliaModule.enable = lib.mkEnableOption "Enable Noctalia Shell";

  config = lib.mkIf config.noctaliaModule.enable {
    
    # 1. Required packages for Plugins and Clipboard
    home.packages = with pkgs; [ 
      cliphist 
      wl-clipboard 
      git
    ];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true; 

      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          weekly-calendar = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
        version = 2;
      };

      settings = {
        bar = {
          density = "compact";
          position = "top";
          
          # 3. Gaps & Floating Look
          marginVertical = 4;
          marginHorizontal = 10;
          backgroundOpacity = 0.8;
          showCapsule = true;
          frameRadius = 12;

          widgets = {
            left = [
              { id = "ControlCenter"; useDistroLogo = true; }
              { id = "MediaMini"; }
              { id = "Tray"; }
            ];
            center = [
              { 
                id = "Workspace"; 
                labelMode = "none";
                hideUnoccupied = false; 
              }
            ];
            right = [
              { id = "SystemMonitor"; }
              { id = "Network"; }
              { id = "Bluetooth"; }
              { id = "Battery"; warningThreshold = 30; }
             { 
              id = "Clock"; 
              formatHorizontal = "ddd, MMM dd  •  HH:mm";
              formatVertical = "HH\nmm";
              useMonospacedFont = false;
              usePrimaryColor = true; 
            }
            ];
          };
        };

        dock = {
          enabled = false;
        };

        colorSchemes = {
          predefinedScheme = "Tokyo Night";
          darkMode = true;
        };

        general = {
          avatarImage = "${config.home.homeDirectory}/.face"; 
          radiusRatio = 1.0;
          enableShadows = true;
          showSessionButtonsOnLockScreen = true;
        };

        wallpaper = {
          enabled = true;
          useWallhaven = true;
          wallhavenQuery = "landscape";
          wallhavenCategories = "111";
          wallhavenPurity = "100";
          fillMode = "crop";
        };

        appLauncher = {
          enableClipboardHistory = true;
          autoPasteClipboard = false;
          clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
          clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        };
        
        osd = {
          enabled = true;
          location = "top_right";
          autoHideMs = 2000;
        };
      };
    };
  };
}
