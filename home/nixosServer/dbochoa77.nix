{ config, ... }: { 
  imports = [ 
    ../dbochoa77
    ../features/cli
    ./home.nix
    ]; 

  features = {
    cli = {
    fastfetch.enable = true;
    };
  };
}

