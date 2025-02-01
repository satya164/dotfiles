{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nano
    neovim
    git
    git-extras
    git-lfs
    gnupg
    jq # json parser
    mosh # ssh replacement
    zsh
    asciinema
    bat # cat replacement
    ccache
    fd # find replacement
    fzf # fuzzy finder
    pinentry_mac # gpg agent
    scrcpy # android screen mirroring
    tmux
    tree
    watchman
    xcbeautify
    gitmux
    idb-companion
    cloudflared
    gh
    yt-dlp
    podman
    vfkit # needed for podman
    lazydocker
  ];

  homebrew = {
    enable = true;
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
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    screencapture.location = "~/Desktop";
  };

  system.stateVersion = 4;
}
