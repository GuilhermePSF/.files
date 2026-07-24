# My NixOS

This is my personal NixOS configuration, built with Flakes, Home-Manager, and Stylix. While it's tailored to my workflow, the modular design makes it easy to adapt for your own use.

## Highlights

-   **Fully Flake-based**: Modern, reproducible, and dependency-managed.
-   **Modular Architecture**: System settings (`confModules`) and user applications (`homeModules`) are cleanly separated.
-   **Centralized User Settings**: Key variables like username, home path, and dotfiles are managed in a single `config.nix` file.
-   **Theming with Stylix**: Palettes are generated from a wallpaper and applied system-wide for a consistent look.
-   **Selectable Desktops**: Easily switch between Hyprland, GNOME, or Niri by changing a single variable in `config.nix`.

## Gallery

| Hyprland (Tiled) | Noctalia (Launcher) |
|------------------|---------------------|
| ![Hyprland](assets/hyprland.png) | ![Noctalia](assets/noctalia.png) |
| **Auto Styling (Stylix)** | **Fastfetch (Shell)** |
| ![Stylix](assets/stylix.png) | ![Fastfetch Screenshot](assets/shell.png) |

## Further Information

-   **[Installation Guide](docs/INSTALLATION.md)**: Step-by-step instructions for setting up this configuration on a new machine.
-   **[Daily Use & Customization](docs/DAILY_USE.md)**: Learn how to customize, extend, and manage this configuration effectively.
