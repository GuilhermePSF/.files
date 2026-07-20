# This is the central configuration file.
# All user-specific settings should be defined here.

{
  # User Configuration
  #
  # Replace with your own username and home directory path.
  username = "gui";
  homeDirectory = "/home/gui";

  # Git Configuration
  #
  # Used for git commits.
  git = {
    name = "GuilhermePSF";
    email = "guilhermepsf23@gmail.com";
  };

  # NixOS Configuration
  nixosConfig = "${homeDirectory}/nixos-config";

  # Obsidian Configuration
  obsidianVault = "GUIs Vault";
  obsidianVaultId = "guilhermesVault";

  # Primary Desktop Environment
  #
  # Select which desktop environment to enable by default.
  # This will install and configure all necessary packages and services.
  #
  # Options: "gnome", "hyprland", "niri"
  desktop = "hyprland";
}
