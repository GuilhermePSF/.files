{
  pkgs,
  lib,
  config,
  ...
}:

let
  userConfig = import ../../config.nix;
in
{
  options.gitModule.enable = lib.mkEnableOption "Enable Git Module";

  config = lib.mkIf config.gitModule.enable {
    programs.git = {
      enable = true;

      settings = {
        user = {
          name = userConfig.git.name;
          email = userConfig.git.email;
        };

        init.defaultBranch = "main";
      };
    };
  };
}
