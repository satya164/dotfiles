{ pkgs, lib, ... }:

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

  security.rtkit.enable = true;

  security.pam.services.ly.enableGnomeKeyring = true;

  services.displayManager.ly.enable = true;
  services.gnome.gnome-keyring.enable = true;

  services.flatpak.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
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
    adwaita-icon-theme
    bibata-cursors
    celluloid
    cliphist
    ghostty
    glib
    google-chrome
    hyprcursor
    hypridle
    hyprland-qt-support
    hyprlock
    hyprpaper
    hyprpicker
    hyprpolkitagent
    hyprshot
    iwgtk
    libnotify
    mako
    nautilus
    nwg-look
    overskride
    playerctl
    rofi-wayland
    vscode
    waybar
    wev
    wl-clipboard
    wlogout
    xdg-user-dirs
    xdg-desktop-portal-hyprland
  ];

  programs.hyprland.enable = true;

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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  system.stateVersion = "25.05";
}
