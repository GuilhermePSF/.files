# Installation Guide

This guide will walk you through setting up this NixOS configuration on a new machine. It assumes you are starting with a fresh NixOS installation, ideally using a graphical installer for convenience.

## Prerequisites

-   A machine ready for NixOS installation.
-   NixOS installation media (USB drive) with a graphical installer (e.g., Calamares).
-   Basic understanding of NixOS and the command line.

## Step-by-Step Installation

### 1. Install NixOS (Graphical Installer)

Perform a standard NixOS installation using your preferred graphical installer.

-   **Partitioning**: If you plan to dual-boot or have specific disk layouts, configure them during this step. Ensure you have a partition for `/` and optionally `/home`.
-   **User Creation**: Create your primary user account. Note the username you choose, as you will use it in `config.nix`.
-   **Flakes Enablement**: Ensure you enable Flakes during the installation process, or configure it manually after installation by adding the following to `/etc/nixos/configuration.nix`:

    ```nix
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false; # Optional, but recommended to avoid warnings from NH
      };
    };
    ```

Once the installation is complete, reboot into your new NixOS system.

### 2. Clone the Repository

After logging into your newly installed NixOS system, you'll need `git` to clone the repository. A fresh minimal NixOS installation may not have `git` pre-installed. You can enter a temporary shell that has `git` available with the following command:

```bash
# This command provides a temporary shell with git, without permanently installing it.
nix-shell -p git
```

Now, from within this new shell, clone this configuration repository.

```bash
# It's recommended to clone it to a consistent location, e.g., ~/.config/nixos
git clone https://github.com/your-username/nixos-config.git ~/.config/nixos
cd ~/.config/nixos
```

**Important**: If you plan to push your changes back to a different repository, update the remote origin:
```bash
git remote set-url origin https://github.com/your-new-username/your-new-repo.git
```

### 3. Configure `config.nix`

The `config.nix` file is the central place for your personal settings. Open it and adjust the **values** to match your system and preferences.

```bash
# Open config.nix with your preferred editor (e.g., nano, vim, or micro)
nano config.nix
```

**Crucial Note**: It is very important that you **only change the values** of the variables, not their names. The rest of the configuration depends on these exact variable names. For example, `nixosConfig` must remain as is.

**Example `config.nix` adjustments:**

```nix
# config.nix
rec {
  # Your chosen username during installation
  username = "your-username";
  # This is derived automatically, no need to change
  homeDirectory = "/home/${username}";

  # This should point to your configuration directory
  nixosConfig = "${homeDirectory}/nixos-config";

  # Your Git identity
  git = {
    name = "Your Full Name";
    email = "your-email@example.com";
  };

  # Your desired desktop environment (e.g., "hyprland", "gnome", "niri")
  desktop = "hyprland";

  # ... other personalized settings
}
```

### 4. Generate Hardware Configuration

You need to generate a hardware-specific configuration file for your machine. This command inspects your system's hardware and creates `hardware-configuration.nix`.

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

**Review this file carefully**:
-   Verify your `fileSystems` are correctly detected.
-   Ensure network interfaces are correct.
-   Make any necessary manual adjustments.

#### Regarding `confModules/mounts.nix`

The `confModules/mounts.nix` file in this repository defines system-specific disk mounts from my personal machine.

**Action Required**: You should **delete or clear this file** (`confModules/mounts.nix`) and configure your own mounts based on your `hardware-configuration.nix` and your specific disk setup. Do not assume the existing mounts will work for you, as they are tied to specific disk UUIDs and paths.

### 5. Build and Switch

Now, apply the configuration to your system. This command will build your NixOS system and switch to the new configuration.

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

-   `sudo nixos-rebuild switch`: Applies the new configuration.
-   `--flake .#nixos-btw`: Specifies that you are building the `nixos-btw` system from the current flake (`.`).

Your system will rebuild, and after completion, your new configuration (including desktop environment, user settings, etc.) will be active. You may need to log out and back in, or reboot, for all changes to take effect.
