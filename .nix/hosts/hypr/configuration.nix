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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "${specialArgs.hostname}";
    networkmanager.enable = true;
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

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.hyprland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs.zsh = {
    enable = true;
  };

  environment.shells = with pkgs; [ zsh ];

  users.defaultUserShell = pkgs.zsh;

  users.users.satya = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    wofi
    waybar
    hyprpaper
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-nerdfont
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

  system.stateVersion = "24.11";

}
