{ pkgs, lib, config, inputs, ... }:

{
  imports = [ inputs.noctalia.homeModules.default ];

  options.noctaliaModule.enable = lib.mkEnableOption "Enable Noctalia Shell";

  config = lib.mkIf config.noctaliaModule.enable {
    
    programs.noctalia-shell = {
      enable = true;
      
      systemd.enable = true; 

      settings = {
        bar = {
          density = "compact";
          position = "top";
          showCapsule = false;
          widgets = {
            left = [
              { id = "ControlCenter"; useDistroLogo = true; }
              { id = "WiFi"; }
              { id = "Bluetooth"; }
            ];
            center = [
              { id = "Workspace"; labelMode = "none"; hideUnoccupied = false; }
            ];
            right = [
              { id = "Battery"; warningThreshold = 30; alwaysShowPercentage = false; }
              { 
                id = "Clock"; 
                formatHorizontal = "HH:mm"; 
                formatVertical = "HH mm"; 
                useMonospacedFont = true; 
                usePrimaryColor = true; 
              }
            ];
          };
        };
        colorSchemes.predefinedScheme = "Monochrome";
        general = {
          avatarImage = "${config.home.homeDirectory}/.face"; 
          radiusRatio = 0.2;
        };
        location = {
          monthBeforeDay = true;
          name = "Lisbon, Portugal";
        };
      };
    };
  };
}
