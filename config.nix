# This is the central configuration file.
# All user-specific settings should be defined here.

rec {
  # User Configuration
  #
  # Replace with your own username and home directory path.
  username = "gui";
  homeDirectory = "/home/${username}";

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

}
