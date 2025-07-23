{ config, lib, pkgs, ... }:

{
  home.username = lib.mkDefault "dbochoa77";
  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  home.stateVersion = "24.11";

  home.packages = with pkgs; [

    # ────── Core Utilities ──────
    rsync
    neovim
    vim
    fastfetch

    # ────── File Sync / Backup ──────
    rclone

    # ────── Networking ──────
    openssh
    mosh
    nmap
    iproute2
    wget
    curl
    inetutils

    # ────── DevOps & Automation ──────
    git
    nix-index

    # ────── NixOS Tools ──────
    nvd
    nix-output-monitor
    nix-tree
    
    cowsay

    # Dev Tools
    nodejs
    unzip

    # Browser
    librewolf
  ];

  home.file = {
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.home-manager.enable = true;
}
