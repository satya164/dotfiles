{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      nixpkgs,
      nix-darwin,
      ...
    }:
    {
      nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/homelab/configuration.nix ];
      };

      nixosConfigurations.hypr = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {
          hostname = "hypr";
          username = "satya";
          timezone = "Europe/Warsaw";
        };
        modules = [ ./hosts/hypr/configuration.nix ];
      };

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/darwin/configuration.nix ];
      };
    };
}
