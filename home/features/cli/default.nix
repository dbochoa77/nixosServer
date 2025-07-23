{pkgs, ...}: {
    imports = [
    ./alias.nix
    ./fastfetch.nix
    ./bash_profile.nix
    ];

  # Upgraded ls
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = ["-l" "--icons" "--git" "-a"];
  };

  # Upgraded cat
  programs.bat = {enable = true;};

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
