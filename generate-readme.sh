#!/bin/sh

# Overwrite README.md with the new, detailed documentation.
cat > README.md << 'EOF'
# My Humble NixOS Configuration

This repository contains a complete, modular, and customizable NixOS configuration using Flakes and Home-Manager. It is designed to be easily adaptable for other users.

## Features

- **Modular Design**: Configuration is split into logical modules for easy management (`confModules` for system-wide, `homeModules` for user-specific).
- **User-Centric Configuration**: A central `config.nix` file to manage all user-specific variables.
- **Selectable Desktop Environments**: Easily switch between GNOME, Hyprland, and Niri.
- **Declarative Home-Manager Setup**: Manages user packages, dotfiles, and services.
- **Stylix Integration**: Declarative and consistent theming across the entire system.

## Installation

Follow these steps to get started with this configuration on a new NixOS machine.

### 1. Prerequisites

Ensure you have a working NixOS installation with Flakes enabled.

### 2. Clone the Repository

Clone this repository to your machine. It's common to place it in `~/.config/nixos` or a similar directory.

```bash
git clone https://github.com/your-username/your-repo-name.git ~/.config/nixos
cd ~/.config/nixos
```

### 3. Configure User Settings

Edit the `config.nix` file to match your personal information and preferences.

```nix
# config.nix

{
  # User Configuration
  username = "your-username";
  homeDirectory = "/home/your-username";

  # Git Configuration
  git = {
    name = "Your Name";
    email = "your-email@example.com";
  };

  # Primary Desktop Environment
  # Options: "gnome", "hyprland", "niri"
  desktop = "gnome";
}
```

### 4. Generate Hardware Configuration

Generate a hardware-specific configuration file for your machine.

```bash
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

This command will create a `hardware-configuration.nix` file in the current directory. **Review this file** and make any necessary adjustments.

### 5. Build and Switch

Build and switch to your new configuration using the `nixos-rebuild` command.

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

The system will now build and apply the configuration.

## Customization

### Enabling/Disabling Modules

You can easily enable or disable modules by toggling the `*.enable` flags in `home.nix`. For example, to disable VSCode, you would change:

```nix
# In home.nix
...
vscodeModule.enable = false; # was true
...
```

### Adding New Modules

1.  Create a new file in `homeModules/` (e.g., `my-new-app/default.nix`).
2.  Define your module configuration in that file.
3.  Add the module to the `imports` list in `home.nix`.
4.  Add an enable flag (e.g., `myNewAppModule.enable = true;`) in `home.nix`.

---
EOF

# Append the repository structure to the new README.
echo "" >> README.md
echo "## Repository Structure" >> README.md
echo "" >> README.md
echo '```' >> README.md
tree -a -I '.git|README.md|README_TODO.md|hardware-configuration.nix|result|update.sh|generate-readme.sh' >> README.md
echo '```' >> README.md