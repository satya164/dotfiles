{ pkgs, ... }:

let
  constants = {
    username = "satya";
  };
in
{
  imports = [
    ../../common/nix.nix
    ../../common/packages.nix
  ];

  system.primaryUser = "${constants.username}";

  environment.systemPackages = with pkgs; [
    gnupg
    pinentry_mac # gpg agent
    rquickshare
    watchman
    ccache
    idb-companion
    xcbeautify
    swiftlint
    cloudflared
    yt-dlp
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
      "cocoapods"
      "xcode-build-server"
      "scrcpy"
    ];
    casks = [
      "affinity"
      "alfred"
      "appcleaner"
      "balenaetcher"
      "beeper"
      "bitwarden"
      "cleanshot"
      "cyberduck"
      "daisydisk"
      "discord"
      "ente-auth"
      "expo-orbit"
      "firefox"
      "ghostty"
      "github-copilot-for-xcode"
      "google-chrome"
      "home-assistant"
      "hoppscotch"
      "iina"
      "imageoptim"
      "jetbrains-toolbox"
      "jordanbaird-ice"
      "latest"
      "maccy"
      "moonlight"
      "muzzle"
      "notunes"
      "obsidian"
      "passepartout"
      "pika"
      "popclip"
      "rustdesk"
      "surfshark"
      "syncthing-app"
      "the-unarchiver"
      "ticktick"
      "visual-studio-code"
      "whatsapp"
    ];
    masApps = {
      "Amperfy" = 1530145038;
      "Folder Quick Look" = 6753110395;
      "iMovie" = 408981434;
      "Infuse" = 1136220934;
      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "OneDrive" = 823766827;
      "Pages" = 409201541;
      "Pixel Perfect Tool" = 1512043611;
      "Pixelmator Pro" = 1289583905;
      "Prime Video" = 545519333;
      "Slack" = 803453959;
      "Steam Link" = 1246969117;
      "Xcode" = 497799835;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  programs.zsh.enable = true;

  security.pam.services.sudo_local = {
    touchIdAuth = true;
  };

  system.defaults = {
    dock.autohide = true;
    dock.mineffect = "scale";
    dock.minimize-to-application = true;
    dock.mru-spaces = false;
    dock.wvous-bl-corner = 1; # Disable
    dock.wvous-br-corner = 1;
    dock.wvous-tl-corner = 2; # Mission Control
    dock.wvous-tr-corner = 1;
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

  system.stateVersion = 6;
}
