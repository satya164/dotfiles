{ inputs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.nixPath = [
    "nixpkgs=${inputs.nixpkgs}"
  ];
}
