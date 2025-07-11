{pkgs, ... } 
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
      defaultnetwork.settings.dns_enabled = true;
    };
  };
  enviroment.systemPackages = with pkgs; [
    podman-compose
  ]
}
