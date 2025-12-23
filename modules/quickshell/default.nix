{ pkgs, lib, config, inputs, ... }: 

{
  options.quickshellModule.enable = lib.mkEnableOption "Enable Quickshell Module";

  config = lib.mkIf config.quickshellModule.enable {
    
    home.packages = [ 
      inputs.quickshell.packages.${pkgs.system}.default
      
      # Dependencies
      pkgs.jq
      pkgs.nerd-fonts.jetbrains-mono
    ];

    # switched to noctalia shell
    # xdg.configFile."quickshell/shell.qml".source = ./shell.qml;
  };
}
