{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.minecraftModule;
in
{
  options.minecraftModule = {
    enable = mkEnableOption "Minecraft server tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      jdk21
      cargo
      rustc
      git
    ];

    home.sessionPath = [ "$HOME/.cargo/bin" ];

    home.activation.installMcman = hm.dag.entryAfter ["writeBoundary"] ''
      export PATH=$PATH:${pkgs.git}/bin:${pkgs.cargo}/bin
      
      if ! [ -f "$HOME/.cargo/bin/mcman" ]; then
        echo "--- Installing mcman via Cargo (this may take a minute) ---"
        ${pkgs.cargo}/bin/cargo install --git https://github.com/ParadigmMC/mcman.git
      else
        echo "--- mcman is already installed in ~/.cargo/bin ---"
      fi
    '';

    home.file."minecraft-servers/.keep".text = "";
  };
}
