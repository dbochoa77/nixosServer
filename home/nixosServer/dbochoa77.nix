{ config, ... }: { 
  imports = [ 
    ../dbochoa77
    ../features/cli
    ./home.nix
    ]; 

  features = {
    cli = {
    fish.enable = true;
    fastfetch.enble = true;
    };
  };
}

