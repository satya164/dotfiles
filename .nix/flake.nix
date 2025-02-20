{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    {
      nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          hostname = "homelab";
          username = "satya";
          domain = "satya164.homes";
          timezone = "Europe/Warsaw";
          storage = "/mnt/storage";
          external = "/mnt/External";
        };
        modules = [ ./hosts/homelab/configuration.nix ];
      };

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [ ./hosts/darwin/configuration.nix ];
      };
    };
}
