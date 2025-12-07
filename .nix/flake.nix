{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin.url = "github:lnl7/nix-darwin/nix-darwin-25.11";
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

      nixosConfigurations.acemagic = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/acemagic/configuration.nix ];
      };

      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit inputs; };
        modules = [ ./hosts/darwin/configuration.nix ];
      };
    };
}
