{
  description = "Custom font declarations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    let
      mkInstallPhase = { srcSubdirectory ? "", fontType ? "truetype" }: ''
        mkdir -p $out/share/fonts
        cp -R $src/${srcSubdirectory} $out/share/fonts/${fontType}/
      '';
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        defaultPackage = pkgs.symlinkJoin {
          name = "customfonts-0.1.0";
          paths = builtins.attrValues self.packages.${system};
        };

        packages.rajdhani =
          let
            url = "https://www.1001fonts.com/download/rajdhani.zip";
          in
          pkgs.stdenvNoCC.mkDerivation {
            name = "rajdhani-font";
            dontConfigure = true;
            src = pkgs.fetchzip {
              inherit url;
              sha256 = "sha256-CLqL7nh8Desn8ZOzz7/tgT+Jvl4M5Dh0PvDr+xpku4k=";
              stripRoot = false;
            };
            installPhase = mkInstallPhase { };
            meta.description = "Rajdhani font family.";
          };
      }
    );
}
