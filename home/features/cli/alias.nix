{
  config, 
  lib,
  ...
}:

{
  programs.bash = {
    enable = true;
    shellAliases = { 
      # Basic
      c = "clear";
      h = "history";
      now = "date +%T";
      ls = "eza";
      grep = "rg";
      ps = "procs";
  
      # Directory movement
      mkdir = "mkdir -p";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../..";
      .4 = "cd ../../../../";
      .5 = "cd ../../../../../";
  
      # Git
      ga = "git add .";
      gc = "git commit -";
      gs = "git status";
  
      # Nix config + rebuild
      nixConfig = "sudo -E nvim /etc/nixos/configuration.nix";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixosServer#nixosServer && home-manager switch --flake ~/nixosServer#nixosServer";
  
      # Neovim (root)
      v = "sudo -E nvim";
    };
  };  
}


