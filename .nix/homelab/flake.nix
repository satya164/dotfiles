{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    {
      nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          hostname = "homelab";
          username = "satya";
          domain = "satya164.homes";
        };
        modules = [ ./configuration.nix ];
      };
    };
}
