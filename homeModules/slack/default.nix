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

    # Slack reads a managed-policies JSON on Linux
    # (~/.config/Slack/managed_storage/com.slack.Slack.json)
    xdg.configFile."Slack/managed_storage/com.slack.Slack.json".text = builtins.toJSON {
      # Launch with native Wayland renderer
      commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
    };
  };
}
