{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.slackModule.enable = lib.mkEnableOption "Enable Slack Module";

  config = lib.mkIf config.slackModule.enable {

    home.packages = [ pkgs.slack ];

    xdg.configFile."Slack/managed_storage/com.slack.Slack.json".text = builtins.toJSON {
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    };
  };
}
