{ config, pkgs, ... }:

let
  constants = {
    hostname = "homelab";
    username = "satya";
    timezone = "Europe/Warsaw";
    domain = "satya164.homes";
    storage = "/mnt/storage";
    external = "/mnt/external";
  };
in
{
  imports = [
    ../../common/nix.nix
    ../../common/packages.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.swraid.mdadmConf = ''
    ARRAY /dev/md0 metadata=1.2 spares=1 UUID=a95ded5d:6e0ec42f:af087785:10409b86
    MAILADDR satyajit.happy@gmail.com
  '';

  fileSystems = {
    "${constants.storage}" = {
      device = "/dev/md0";
      fsType = "ext4";
      options = [
        "rw"
        "user"
        "nofail"
      ];
    };
    "${constants.external}" = {
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

  time.timeZone = "${constants.timezone}";

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

  users.users.${constants.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    uid = 1000;
  };

  services.getty.autologinUser = "${constants.username}";

  environment.systemPackages = with pkgs; [
    mdadm
    gcc
    tailscale
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };

  services.tailscale.enable = true;

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 5 * * *      root    rsync -avzog --delete --exclude 'docker' ${constants.storage}/ ${constants.external} >> /var/log/rsync.log"
    ];
  };

  services.samba = {
    package = pkgs.samba4Full;
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "${constants.hostname}";
        "netbios name" = "${constants.hostname}";
        "smb encrypt" = "required";
        "security" = "user";
        "browseable" = "yes";
      };

      "nix" = {
        "path" = "${config.users.users.${constants.username}.home}/.nix";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "${constants.username}";
      };
      "storage" = {
        "path" = "${constants.storage}";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "${constants.username}";
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
      data-root = "${constants.storage}/docker";
    };
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";
        hostname = "portainer";
        ports = [ "9000:9000" ];
        volumes = [
          "${constants.storage}/AppData/portainer:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        environment = {
          APPDATA = "${constants.storage}/AppData";
          STORAGE = "${constants.storage}";
          DOMAIN = "${constants.domain}";
          PUID = "${toString config.users.users.${constants.username}.uid}";
          PGID = "${toString config.ids.gids.${toString config.users.users.${constants.username}.group}}";
          TZ = "${constants.timezone}";
        };
        labels = {
          "traefik.http.routers.portainer.rule" = "Host(`portainer.${constants.domain}`)";
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
