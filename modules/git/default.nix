{ pkgs, lib, config, ... }:

{
  options.gitModule.enable = lib.mkEnableOption "Enable Git Module";

  config = lib.mkIf config.gitModule.enable {
    programs.git = {
      enable = true;
      userName = "GuilhermePSF";
      userEmail = "guilhermepsf23@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
