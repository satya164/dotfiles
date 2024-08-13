{
  description = "satya164's macOS flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [
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
        rbenv
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
      ];

      services.nix-daemon.enable = true;

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;

      security.pam.enableSudoTouchIdAuth = true;

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;

      nixpkgs.hostPlatform = "x86_64-darwin";

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        screencapture.location = "~/Desktop";
      };
    };
  in
  {
    darwinConfigurations."INV-0068" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    darwinPackages = self.darwinConfigurations."INV-0068".pkgs;
  };
}
