{
  description = "Configuration for Nixos Server";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
#    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flakes-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
#	inputs.nixpkgs.follows="nixpkgs";
  
  };

    outputs = { 
	self, 
	home-manager, 
	nixpkgs,
	...
    } @ inputs: let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
      packages = 
        forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays {inherit inputs outputs;};
      nixosConfiguration = {
        nixosServer = nixpkgs.lib.nixosSystem {
	  specialArgs = {inherit inputs outputs;};
	  modules = [./hosts/nixosServer];
	};
      };
      homeConfigurations = { 
        "nixosServer@nixosServer" = home-manager.lib.homeManagerConfiguration {
	  pkgs = nixpkgs.legacyPackages."x86_64-linux";
	  extraSpecialArgs = {inherit inputs outputs;};
	  modules = [./home/dbochoa77/nixosSever.nix];
	};
      };
    };
} 
