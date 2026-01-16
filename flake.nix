{
    description = "The flake for all the software I package";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    outputs = { self, nixpkgs }:
    let
        systems = [ "x86_64-linux" "aarch64-linux" ];
        forAllSystems = nixpkgs.lib.genAttrs systems;
    in {
        overlays.default = final: prev: import ./pkgs { pkgs = final; };

        packages = forAllSystems (system:
        let
            pkgs = import nixpkgs {
                inherit system;
                overlays = [ self.overlays.default ];
            };
        in {
            inherit (pkgs) librepods;
            default = pkgs.librepods;
        }
        );
    };
    
}
