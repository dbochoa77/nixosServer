{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixServer"; # Define your hostname.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Firewall
  networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 1883 3000 8096 9090 ];
      allowedUDPPorts = [ 53 51820];
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dbochoa77 = {
    isNormalUser = true;
    description = "dbochoa77";
    extraGroups = [ "media" "networkmanager" "wheel" "docker" ];
  };

  users.users.guest = {
    isNormalUser = true;
    description = "Temporary Guest Demo";
    home = "/home/guest";
    createHome = true; 
    shell = pkgs.bash;
    extraGroups = [ "networkmanager" "video"];
    password = "afsjdpg)*_)%fpdoa903";
  };

  # Jelly fin user
  users.groups.media = {};

  users.users.jellyfin = {
    isSystemUser = true;
    extraGroups = [ "media" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
  
  # ────── Core Utilities ──────
  htop
  btop
  tmux
  rsync
  ripgrep
  fd
  ncdu
  bash-completion
  file
  neovim
  vim 
  fastfetch

  # ────── File Sync / Backup ──────
  rclone
  borgbackup
  restic
  syncthing

  # ────── Networking ──────
  openssh
  mosh
  nmap
  iproute2
  wget
  curl
  inetutils

  # ────── Security ──────
  nftables
  fail2ban
  gnupg
  openssl

  # ------ Jellyfin -------
  pkgs.jellyfin
  pkgs.jellyfin-web
  pkgs.jellyfin-ffmpeg
 
  # ────── Web & Containers ──────
  nginx
  caddy
  docker
  docker-compose
  podman
  traefik

  # ────── Monitoring & Logging ──────
  prometheus
  grafana
  uptime-kuma
  glances
  logrotate

  # ────── DevOps & Automation ──────
  git
  ansible
  nixfmt-classic
  direnv
  nix-index
  home-manager

  # ────── Virtualization ──────
  qemu
  libvirt
  virt-manager
  vagrant
  spice-vdagent

  # ────── NixOS Tools ──────
  nvd
  nix-output-monitor
  nix-tree

  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # System State Version
  system.stateVersion = "25.05"; # Did you read the comment?

  # QEMU Tool
  services.spice-vdagentd.enable = true;
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["dbochoa77"];
  virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
  };

  # Jellyfin  
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

# Nextcloud
  environment.etc."nextcloud-admin-pass".text = "PWD";
  services.nextcloud = {
      enable = true;
      package = pkgs.nextcloud31;
      hostName = "localhost";
      config.adminpassFile = "/etc/nextcloud-admin-pass";
      config.dbtype = "sqlite";
  };

# NGINX FRONTEND
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
  virtualHosts."dashboard.local" = {
    root = "/srv/dashboard";
    locations."/" = {
      index = "index.html";
    };
  locations."/style.css" = {
    extraConfig = ''
    default_type text/css;
      '';
    };
  };
};

  # Grafana
  services.grafana = {
    enable = true;
    settings.server = {
      http_port = 3000;
      http_addr = "0.0.0.0";
    };
  };

  # Prometheus 
  services.prometheus = {
    enable = true;
    port = 9090;

  scrapeConfigs = [
    {
      job_name = "prometheus";
      static_configs = [
        { targets = [ "localhost:9090" ]; }
      ];
    }

    {
      job_name = "node";
      static_configs = [
        { targets = [ "localhost:9100" ]; }
      ];
    }
  ];
};

  # Node Exporter (collects system metrics)
  services.prometheus.exporters.node = {
    enable = true;
    port = 9100;
  };

  # Mosquitto 
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
  };

# Wireguard
  # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];

  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = "/etc/wireguard/privatekey";

      peers = [
        # Guest
        { # Feel free to give a meaningful name
          # Public key of the peer (not a file path).
          publicKey = "D+aZjkFYRKPsbNIuO881423jMNxszqggii3IFm/6LAg=";
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
          allowedIPs = [ "10.100.0.2/32" ];
        }
        { # Jody
          publicKey = "X5R1sP4R7zerty7CLNTlqVBd/5bKjAMxiuoChRflwBg=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };

  # Docker
  virtualisation.docker.enable = true;

}
