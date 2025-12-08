{ pkgs, lib, config, ... }:

{
  options.fastfetchModule.enable = lib.mkEnableOption "Enable Fastfetch Module";

  config = lib.mkIf config.fastfetchModule.enable {
    
    home.packages = [ pkgs.fastfetch ];

    xdg.configFile."fastfetch/config.jsonc".text = ''
      {
        "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
        "logo": {
          "source": "nixos_small",
          "padding": {
            "right": 2
          }
        },
        "display": {
          "separator": "  ",
          "color": {
            "keys": "magenta"
          },
          "size": {
            "ndigits": 0,
            "maxPrefix": "MB"
          }
        },
        "modules": [
          {
            "type": "title",
            "color": {
              "user": "green",
              "at": "red",
              "host": "blue"
            }
          },
          {
            "type": "os",
            "key": "  distro",
            "keyColor": "yellow"
          },
          {
            "type": "kernel",
            "key": "  kernel",
            "keyColor": "blue"
          },
          {
            "type": "uptime",
            "key": "  uptime",
            "keyColor": "cyan"
          },
          {
            "type": "shell",
            "key": "  shell",
            "keyColor": "magenta"
          },
          {
            "type": "packages",
            "key": "  pkgs",
            "keyColor": "red"
          },
          {
            "type": "memory",
            "key": "  memory",
            "keyColor": "yellow"
          },
          "break",
          {
            "type": "colors",
            "symbol": "circle"
          }
        ]
      }
    '';
  };
}
