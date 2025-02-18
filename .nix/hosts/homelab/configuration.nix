{
  config,
  pkgs,
  specialArgs,
  ...
}:

{
  imports = [
    ../../common/packages.nix
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fileSystems = {
    "${specialArgs.external}" = {
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
    hostName = "${specialArgs.hostname}";
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

  time.timeZone = "${specialArgs.timezone}";

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

  users.users.${specialArgs.username} = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    uid = 1000;
  };

  services.getty.autologinUser = "${specialArgs.username}";

  environment.systemPackages = with pkgs; [
    gcc
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
        "server string" = "${specialArgs.hostname}";
        "netbios name" = "${specialArgs.hostname}";
        "smb encrypt" = "required";
        "security" = "user";
        "browseable" = "yes";
      };

      "External" = {
        "path" = "${specialArgs.external}";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "${specialArgs.username}";
      };
      "Nix" = {
        "path" = "${config.users.users.${specialArgs.username}.home}/.nix";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "${specialArgs.username}";
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
      data-root = "${specialArgs.external}/Docker";
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
          "${specialArgs.external}/AppData/portainer:/data"
          "/var/run/docker.sock:/var/run/docker.sock"
        ];
        environment = {
          APPDATA = "${specialArgs.external}/AppData";
          EXTERNAL = "${specialArgs.external}";
          DOMAIN = "${specialArgs.domain}";
          PUID = "${toString config.users.users.${specialArgs.username}.uid}";
          PGID = "${toString config.ids.gids.${toString config.users.users.${specialArgs.username}.group}}";
          TZ = "${specialArgs.timezone}";
        };
        labels = {
          "traefik.http.routers.portainer.rule" = "Host(`portainer.${specialArgs.domain}`)";
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
