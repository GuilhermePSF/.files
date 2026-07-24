# Daily Use and Customization Guide

This document provides guidelines on how to use, customize, and extend this NixOS configuration effectively. Understanding these principles will help you maintain a clean, modular, and portable setup.

## The `config.nix` File: Your Control Center

The `config.nix` file is the heart of your personal setup. All user-specific variables are defined here. When you want to change your Git identity, select a different desktop, or tweak other high-level settings, this is the first place to look.

**Key takeaway**: Keep all your personal variables in `config.nix`. This makes your configuration portable and easy to manage.

## Managing Applications: The Modular Approach

This configuration uses a modular pattern for managing user applications and their settings. You can find these modules in the `homeModules/` directory.

### How to Enable or Disable an Application Module

Application modules are enabled or disabled in `home.nix`. To disable an application, simply set its `enable` flag to `false`.

For example, to disable Zed:
```nix
# In home.nix
...
zedModule.enable = false; // Was true
...
```
Rebuild your system (`sudo nixos-rebuild switch --flake .#nixos-btw`) to apply the change.

### How to Add a New Application

Follow these steps to add a new application declaratively:

1.  **Create a Module**: Create a new directory and a `default.nix` file inside `homeModules/`. For example, `homeModules/my-app/default.nix`.
2.  **Define the Module**: In `homeModules/my-app/default.nix`, create a standard NixOS module structure. Install the package and configure its dotfiles.

    ```nix
    # homeModules/my-app/default.nix
    { pkgs, lib, config, ... }:

    {
      # Define an option to enable/disable this module
      options.myAppModule.enable = lib.mkEnableOption "Enable My App";

      # The configuration to apply if the module is enabled
      config = lib.mkIf config.myAppModule.enable {
        # Install the package
        home.packages = [ pkgs.my-app ];

        # Manage dotfiles declaratively
        xdg.configFile."my-app/config.json".text = ''
          {
            "setting": "value"
          }
        '';
      };
    }
    ```

3.  **Import and Enable**: In `home.nix`, import your new module and set its enable flag to `true`.

    ```nix
    # In home.nix
    imports = [
      ...
      ./homeModules/my-app
    ];

    ...

    myAppModule.enable = true;
    ```

## Anti-Patterns and Best Practices

### The `packages.nix` File

**Anti-Pattern**: Do not add all your personal GUI applications or command-line tools to `confModules/packages.nix`.

**Best Practice**: The `environment.systemPackages` list in `confModules/packages.nix` is for essential, system-wide packages required by all users or for the system to function correctly (e.g., `git`, `wget`, `bluez`).

Most of your user-facing applications (like browsers, editors, media players) should be managed through dedicated `homeModules` and installed via `home.packages`. This keeps your system configuration clean and ties application packages to their configurations.



### Why `git add` is Necessary

Your NixOS configuration is declarative, and `git` is the tool you use to track its state. When you make a change, you should always stage and commit it.

-   **Reproducibility**: `git` allows you to see the exact history of your system's configuration. If a change breaks something, you can use `git diff` to see what changed and `git checkout` to revert to a working state.
-   **Flakes and Purity**: Flakes lock the versions of your inputs (like `nixpkgs`) in `flake.lock`. By default, Nix warns you if you try to build from a "dirty" (uncommitted) Git repository, because the state is not well-defined. Committing your changes ensures that every build is based on a known, reproducible state.
-   **Peace of Mind**: Knowing that your entire system configuration is tracked in Git gives you the confidence to experiment. If you make a mistake, you can always go back.

Always run `git add .` and `git commit` after you have confirmed a change works.


## Repository Structure

This provides an overview of the configuration's layout.

```
.
├── config.nix
├── configuration.nix
├── confModules
│   ├── audio.nix
│   ├── boot.nix
│   ├── desktop.nix
│   ├── mounts.nix
│   ├── networking.nix
│   ├── packages.nix
│   ├── stylix
│   │   ├── default.nix
│   │   ├── wallpaper-black.jpg
│   │   └── wallpaper.jpg
│   └── users.nix
├── docs
│   ├── DAILY_USE.md
│   └── INSTALLATION.md
├── flake.lock
├── flake.nix
├── flakes
│   └── core
│       └── volume
├── generate-readme.sh
├── .gitignore
├── hardware-configuration.nix
├── homeModules
│   ├── brave
│   │   └── default.nix
│   ├── devtools
│   │   └── default.nix
│   ├── fastfetch
│   │   ├── default.nix
│   │   └── sunflower.png
│   ├── firefox
│   │   └── default.nix
│   ├── ghostty
│   │   └── default.nix
│   ├── git
│   │   └── default.nix
│   ├── gnome
│   │   └── default.nix
│   ├── hyprland
│   │   └── default.nix
│   ├── jetbrains
│   │   └── default.nix
│   ├── krita
│   │   └── default.nix
│   ├── media
│   │   └── default.nix
│   ├── minecraft
│   │   └── default.nix
│   ├── nautilus
│   │   └── default.nix
│   ├── neovim
│   │   └── default.nix
│   ├── nh
│   │   └── default.nix
│   ├── niri
│   │   └── default.nix
│   ├── noctalia
│   │   └── default.nix
│   ├── obsidian
│   │   └── default.nix
│   ├── organize
│   │   └── default.nix
│   ├── pavucontrol
│   │   └── default.nix
│   ├── playit
│   │   └── default.nix
│   ├── slack
│   │   └── default.nix
│   ├── spicetify
│   │   └── default.nix
│   ├── vesktop
│   │   └── default.nix
│   ├── vscode
│   │   └── default.nix
│   ├── zed
│   │   └── default.nix
│   └── zsh
│       ├── aliases.nix
│       └── default.nix
├── home.nix
├── hyprland.png
├── noctalia.png
├── README.md
├── shell.png
└── stylix.png

35 directories, 54 files
```
