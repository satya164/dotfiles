{
  description = "satya164's macOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
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

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        screencapture.location = "~/Desktop";
      };
    };
  in
  {
    darwinConfigurations.macbook = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ configuration ];
    };

    darwinConfigurations."INV-0068" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ configuration ];
    };

    darwinConfigurations."INV-0281" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ configuration ];
    };
  };
}
