{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    fonts = {
      url = "path:fonts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ichikaCursor = {
      url = "path:ichika-cursor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dolphin-overlay = {
      url = "github:rumboon/dolphin-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neopywal = {
      url = "github:RedsXDD/neopywal.nvim/v2.6.0";
      flake = false;
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qml-niri = {
      url = "github:imiric/qml-niri/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    globalprotect-openconnect = {
      url = "github:yuezk/GlobalProtect-openconnect";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-darwin,
      ...
    }@inputs:
    let
      mkPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = let
        system = "x86_64-linux";
      in
      {
        asahina = nixpkgs.lib.nixosSystem {
          inherit system;
          pkgs = mkPkgs system;
          specialArgs = { inherit inputs; };
          modules = [
            {
              nixpkgs.overlays = [ inputs.dolphin-overlay.overlays.default ];
            }
            inputs.musnix.nixosModules.musnix
            ./asahina/configuration.nix
            home-manager.nixosModules.home-manager
            inputs.nix-flatpak.nixosModules.nix-flatpak
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "old";
                users.mocha = ./asahina/home.nix;
                extraSpecialArgs = {
                  inherit inputs;
                };
              };
            }
          ];
        };
      };
      darwinConfigurations = let
        system = "aarch64-darwin";
      in
      {
        akiyama = nix-darwin.lib.darwinSystem {
          inherit system;
          pkgs = mkPkgs system;
          specialArgs = { inherit inputs; };
          modules = [
            ./akiyama/configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.mocha = ./akiyama/home.nix;
                extraSpecialArgs = {
                   inherit inputs;
                };
              };
            }
          ];
        };
      };
    };
}
