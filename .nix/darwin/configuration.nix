{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nixfmt-rfc-style
    nano
    neovim
    wget
    git
    git-extras
    git-lfs
    gitmux
    tmux
    tree
    gnupg
    jq # json parser
    mosh # ssh replacement
    fd # find replacement
    fzf # fuzzy finder
    zoxide # cd replacement
    bat # cat replacement
    yazi # file manager
    ncdu # disk usage
    hyperfine # benchmarking tool
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
    lazydocker
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
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    screencapture.location = "~/Desktop";
  };

  system.stateVersion = 4;
}
