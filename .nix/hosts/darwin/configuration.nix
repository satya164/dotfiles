{ pkgs, ... }:

{
  imports = [
    ../../common/nix.nix
    ../../common/packages.nix
  ];

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry_mac # gpg agent
    scrcpy # android screen mirroring
    watchman
    ccache
    idb-companion
    xcbeautify
    cloudflared
    yt-dlp
    asciinema
    podman
    podman-compose
    vfkit # needed for podman
    gh
  ];

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap"; # remove brews not in the list
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    taps = [
      "sdkman/tap"
      "nikitabobko/tap"
    ];
    brews = [
      "n"
      "yarn"
      "sdkman-cli"
      "rbenv"
      "ruby-build"
    ];
    casks = [
      "ghostty"
      "jordanbaird-ice"
      "ente-auth"
      "home-assistant"
      "maccy"
      "obsidian"
      "pika"
      "shottr"
      "syncthing"
      "the-unarchiver"
      "expo-orbit"
    ];
  };

  fonts.packages = with pkgs; [
    fira-code
    fira-code-nerdfont
  ];

  programs.zsh.enable = true;

  security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  system.defaults = {
    dock.autohide = true;
    dock.mineffect = "scale";
    dock.minimize-to-application = true;
    dock.mru-spaces = false;
    dock.wvous-bl-corner = 11; # Launchpad
    dock.wvous-br-corner = 4; # Show Desktop
    dock.wvous-tl-corner = 2; # Mission Control
    dock.wvous-tr-corner = null;
    finder.AppleShowAllExtensions = true;
    finder.FXDefaultSearchScope = "SCcf"; # Search current folder
    finder.FXEnableExtensionChangeWarning = false;
    finder.FXRemoveOldTrashItems = true;
    finder.NewWindowTarget = "Home";
    magicmouse.MouseButtonMode = "TwoButton";
    menuExtraClock.Show24Hour = true;
    menuExtraClock.ShowDate = 0; # Show date when space is available
    screencapture.location = "~/Desktop";
    spaces.spans-displays = false;
    trackpad.Clicking = true;
    WindowManager.EnableStandardClickToShowDesktop = false;
    WindowManager.EnableTiledWindowMargins = false;
    WindowManager.EnableTilingByEdgeDrag = true;
    WindowManager.EnableTopTilingByEdgeDrag = true;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    NSGlobalDomain.AppleEnableMouseSwipeNavigateWithScrolls = false;
    NSGlobalDomain.AppleEnableSwipeNavigateWithScrolls = false;
    NSGlobalDomain.AppleScrollerPagingBehavior = true;
    NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
  };

  system.stateVersion = 4;
}
