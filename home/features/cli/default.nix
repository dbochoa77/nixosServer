{pkgs, ...}: {
    imports = [
    ./alias.nix
    ];

  home.packages = with pkgs; [
    coreutils 
    fd
    htop
    httpie
    jq
    procs
    ripgrep
    tldr
    zip 
  ];
}
