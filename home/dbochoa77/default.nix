{
  config,
  lib,
  outputs,
  pkgs,
  ...
}: {
 
    nixpkgs = {
    # Overlays
    overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
    outputs.overlays.stable-packages
  ];

    # Allows closed sourced packages
    config = {
    allowUnfree = true;
  };
};

  # Enables Flakes and nix-command
  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };
}
