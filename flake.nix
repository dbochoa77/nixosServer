{
  description = "Configuration for Nixos Server";

 inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # For making declaritive partions
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My Neovim configurtion for homemanager
    dotfiles = {
    url = "git+https://github.com/dbochoa77/nvim.git";
    flake = false;
    };
  };

  outputs = { 
	self, 
        disko,
	dotfiles,
	home-manager,
	nixpkgs,
	...
    } @ inputs: let
      inherit (self) outputs;
      systems = [
        "x86_64-linux"
	"i686-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Host and User Name 
      host = "nixosServer"; 
      user = "dbochoa77";  

 in {
    packages =
      forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    overlays = import ./overlays {inherit inputs;};


    nixosConfigurations = {
        "${host}" = nixpkgs.lib.nixosSystem {
	  specialArgs = {inherit inputs outputs;};
	  modules = [
	    ./hosts/${host}/configuration.nix
	    inputs.disko.nixosModules.disko
	  ];
	};
      };
      homeConfigurations = { 
        "${host}" = home-manager.lib.homeManagerConfiguration {
	  pkgs = nixpkgs.legacyPackages.${systems};
	  extraSpecialArgs = {inherit inputs outputs;};
	  modules = [./home/${host}/${user}.nix];
	};
      };
    };
} 
