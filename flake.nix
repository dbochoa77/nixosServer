{
  description = "Configuration for Nixos Server";

 inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    
    dotfiles = {
    url = "git+https://github.com/dbochoa77/nvim.git";
    flake = false;
    };
  };

  outputs = { 
	self, 
	dotfiles,
	home-manager,
	nixpkgs,
	...
    } @ inputs: let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
	"i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
  
  in {
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};


    nixosConfigurations = {
        nixosServer = nixpkgs.lib.nixosSystem {
	  specialArgs = {inherit inputs outputs;};
	  modules = [
            { networking.hostName = hostName; }
	    ./hosts/${hosts}/configuration.nix
	    #		     ./hosts/nixosServer/hardware-configuration.nix
	  ];
	};
      };
      homeConfigurations = { 
        "nixosServer" = home-manager.lib.homeManagerConfiguration {
	  pkgs = nixpkgs.legacyPackages."x86_64-linux";
	  extraSpecialArgs = {inherit inputs outputs;};
	  modules = [./home/nixosServer/dbochoa77.nix];
	};
      };
    };
} 
