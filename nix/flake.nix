{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyNixHelper = {
      url = "github:b-src/lazy-nix-helper.nvim";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, homeManager, ... } @ inputs:
  let
    pkgs = import nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };
    lazyNixHelper = pkgs.vimUtils.buildVimPlugin {
      name = "lazy-nix-helper";
      src = inputs.lazyNixHelper;
    };
  in
  {
    nixosConfigurations = {
      asahina = nixpkgs.lib.nixosSystem {
        pkgs = pkgs;
        specialArgs = { lazyNixHelper = lazyNixHelper; };
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          homeManager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.mocha = ./home.nix;
            };
          }
        ];
      };
    };
  };
}
