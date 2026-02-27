{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.gitModule.enable = lib.mkEnableOption "Enable Git Module";

  config = lib.mkIf config.gitModule.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = "GuilhermePSF";
          email = "guilhermepsf23@gmail.com";
        };

        init.defaultBranch = "main";
      };
    };
  };
}
