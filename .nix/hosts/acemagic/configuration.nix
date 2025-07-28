{ config, pkgs, ... }:

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

  networking = {
    hostName = "${constants.hostname}";
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${constants.username} = {
    isNormalUser = true;
    description = "${constants.fullname}";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  environment.systemPackages = with pkgs; [
    (
      google-chrome.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
        ];
      }
    )
    ghostty
  ];


  system.stateVersion = "25.05";
}
