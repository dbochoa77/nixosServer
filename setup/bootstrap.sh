#!/bin/bash

ping -c 4 google.com & 

git clone https://github.com/dbochoa77/nixosServer
wait

cp /etc/nixos/hardware-configuration.nix ~/nixosServer/hosts/

rm -f /home/dbochoa77/nixosServer/hosts/hardware-configuration.nix
wait

sudo nixos-rebuild switch --flake ~/nixosServer#nixosServer
home-manager switch --flake ~/nixosServer#nixosServer
