{pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true; #Allows copy and paste of docker commands
      

      # Cleans the unused containers
      autoPrune = { 
	enable = true;
	dates = "weekly";
	flags = [
	  "--filter=until=24h"
	  "--filter=label!=important"
	];
      };
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  environment.systemPackages = with pkgs; [
    podman-compose
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
  ];
}
