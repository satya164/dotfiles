{ pkgs, ... }:

let
  constants = {
    hostname = "acemagic";
    username = "satya";
    fullname = "Satyajit Sahoo";
  };
in
{
  imports = [
    ../../common/nix.nix
    ../../common/packages.nix
    ../../common/linux.nix
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  networking = {
    hostName = "${constants.hostname}";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.flatpak.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "${constants.username}";
    dataDir = "/home/${constants.username}";
  };

  users.users.${constants.username} = {
    isNormalUser = true;
    description = "${constants.fullname}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.sessionVariables = {
    # Fix blurry Electron apps on Wayland
    # May need "socket=wayland" set for flatpak apps (e.g. with Flatseal)
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = 1;
  };

  environment.systemPackages = with pkgs; [
    google-chrome
    vscode
    ghostty
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.fira-code
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "Fira Code Nerd Font Mono" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  system.stateVersion = "25.05";
}
