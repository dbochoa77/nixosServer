{ config, lib, pkgs, ... }:

{
  home.username - lib.mkDefault "dbochoa77";
  home.homeDirecotry = lib.mkDefault "/home/${config.home.username}";

  home.stateVerision = "24.05";

  home.packages [
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
