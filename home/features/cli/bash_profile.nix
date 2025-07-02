 { config, lib, pkgs, ... }:

{
  programs.bash.loginShellInit = ''
    fastfetch
  '';
}

