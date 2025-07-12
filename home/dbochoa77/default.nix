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

    config = {
    allowUnfree = true;
  };
};

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes"];
      warn-dirty = false;
    };
  };
}
