# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "/mnt/External" = {
      device = "/dev/disk/by-uuid/9a5cdc5e-362f-eb4e-9f9a-8ca6ed0d6671";
      fsType = "ext4";
      options = [
        "rw"
        "user"
        "nofail"
      ];
    };
  };

  networking = {
    hostName = "homelab";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        # Home Assistant
        8123
        21064 # HomeKit Bridge
        # Music Assistant
        8095
        8097
        # Mosquitto
        1883
        # Jellyfin
        8096
        8920
      ];
      allowedUDPPorts = [
        # Jellyfin
        1900
        7359
      ];
    };
  };

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  programs.zsh = {
    enable = true;
  };

  environment.shells = with pkgs; [ zsh ];

  users.defaultUserShell = pkgs.zsh;

  users.users.satya = {
    isNormalUser = true;
    description = "Satyajit Sahoo";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  users.groups.docker.gid = lib.mkForce 1000;

  services.getty.autologinUser = "satya";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    wget
    docker-compose
    git
    tailscale
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.mosh.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  services.tailscale.enable = true;

  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "homelab";
        "netbios name" = "homelab";
        "smb encrypt" = "required";
        "security" = "user";
        "browseable" = "yes";
      };

      "DATA" = {
        "path" = "/DATA";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "satya";
      };
      "External" = {
        "path" = "/mnt/External";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "satya";
      };
      "Nix" = {
        "path" = "/home/satya/.nix";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "satya";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  services.journald = {
    extraConfig = ''
      SystemMaxUse=100M
    '';
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      userland-proxy = false;
      data-root = "/mnt/External/Docker";
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      traefik = {
        autoStart = true;
        image = "traefik:latest";
        hostname = "traefik";
        serviceName = "traefik";
        ports = [
          "80:80"
          "443:443"
          "8080:8080"
        ];
        volumes = [
          "/DATA/AppData/traefik:/etc/traefik"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "Europe/Warsaw";
        };
        labels = {
          "traefik.http.routers.traefik.rule" = "Host(`traefik.satya164.homes`)";
          "traefik.http.services.traefik.loadbalancer.server.port" = "8080";
        };
        extraOptions = [ "--network=traefik" ];
      };
      portainer = {
        autoStart = true;
        image = "portainer/portainer-ce:latest";
        hostname = "portainer";
        serviceName = "portainer";
        ports = [ "9000:9000" ];
        volumes = [
          "/DATA/AppData/portainer:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        environment = {
          APPDATA = "/DATA/AppData";
          EXTERNAL = "/mnt/External";
          DOMAIN = "satya164.homes";
          PUID = "1000";
          PGID = "1000";
          TZ = "Europe/Warsaw";
        };
        labels = {
          "traefik.http.routers.portainer.rule" = "Host(`portainer.satya164.homes`)";
          "traefik.http.services.portainer.loadbalancer.server.port" = "9000";
        };
        extraOptions = [ "--network=traefik" ];
      };
    };
  };

  systemd.services.traefik-network = {
    description = "Create the network bridge for traefik.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
      check=$(${pkgs.docker}/bin/docker network ls | grep "traefik" || true)
      if [ -z "$check" ]; then
        ${pkgs.docker}/bin/docker network create traefik
      fi
    '';
  };

  system.stateVersion = "24.11";
}
