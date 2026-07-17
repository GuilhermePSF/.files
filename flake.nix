{
  description = "My NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/3abfa1fc09b62dc4cdeeb7b787886f075696f0b7";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zed-extensions = {
      url = "github:DuskSystems/nix-zed-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/e31c79f571c5595a155f84b9d77ce53a84745494";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      stylix,
      rust-overlay,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix

          stylix.nixosModules.stylix

          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
              inputs.zed-extensions.overlays.default
              rust-overlay.overlays.default

              (
                final: prev:
                let
                  latestRustPlatform = final.makeRustPlatform {
                    cargo = final.rust-bin.stable.latest.default;
                    rustc = final.rust-bin.stable.latest.default;
                  };
                in
                {
                  nix-zed-extensions = prev.nix-zed-extensions.override {
                    rustPlatform = latestRustPlatform;
                  };

                }
              )
            ];
          }

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              sharedModules = [
                inputs.zed-extensions.homeManagerModules.default
              ];
              users.gui = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
