{ config, pkgs, ... }:
 
{ 
  virtualisation = { 
  libvirtd.enable = true;
  qemu.package = pkgs.qemu_kvm;
  spiceUSBRedirection.enable = true;
};

  users.users.dbochoa77.extraGroups = [ "libvirtd" "kvm" ];

environment.systemPackages = with pkgs; [
    qemu_kvm
    virtiofsd   # optional: for shared folder support
    dnsmasq     # optional: if using user-mode networking
  ];
}
