{
 imports = [
   ./harware-configuration.nix
   inputs.home-manager.nixosModules.home-manager
];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dbochoa77 = {
    isNormalUser = true;
    description = "dbochoa77";
    extraGroups = [ "media" "networkmanager" "wheel" "docker" ];
  };

home-manager = {
  userUserPackages = true;
  extraSpecialArgs = { inherit inputs outputs; };
  users.dbochoa77 = 
    import ../../home/dbochoa77/${config.networkingi.hostName}.nix;
  };

networking.hostName = "nixosServer";
{
  imports = [../dbochoa77 ./configuration.nix];
}
