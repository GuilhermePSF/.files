{
  description = "My NixOS configuration with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";  # Pin to a specific branch or commit
    quickshell.url = "github:outfoxxed/quickshell";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";  # Pin Home Manager
      inputs.nixpkgs.follows = "nixpkgs";  # Ensure it uses the same nixpkgs version
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";  # Architecture for your system
      specialArgs = {inherit inputs; };
      modules = [
        ./configuration.nix  # Your NixOS system configuration
        home-manager.nixosModules.home-manager  # Add the Home Manager module
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
	    extraSpecialArgs = { inherit inputs; };
            users.gui = import ./home.nix;  # Your home manager configuration file
            backupFileExtension = "backup";
          };
        }
      ];
      
    };
  };
}

