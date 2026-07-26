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

Nix flakes don't read your working directory directly, they read the Git **index** (whatever `git add` has staged, or already committed). Any file that isn't tracked by Git essentially doesn't exist as far as the flake is concerned.

This has a very concrete consequence: if you create a new file (say, a new module at `homeModules/my-app/default.nix`) and forget to `git add` it, `nixos-rebuild switch` will fail with a "path does not exist" or similar error — even though the file is right there on disk. Nix isn't being pedantic about cleanliness; it genuinely cannot see the file yet.

**Practical rule**: any time you add a new file to the config, `git add` it *before* rebuilding, not after confirming it works. Otherwise you'll spend time debugging a "missing file" error that's really just an unstaged file.


## Repository Structure

This provides an overview of the configuration's layout.

```
.
├── assets
│   ├── hyprland.png
│   ├── noctalia.png
│   ├── shell.png
│   └── stylix.png
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
│   ├── steam
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
├── README.md
└── scripts
    └── generate-readme.sh

38 directories, 55 files
```
