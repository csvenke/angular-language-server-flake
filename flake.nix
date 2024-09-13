{
  description = "angular-language-server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      imports = [
        inputs.flake-parts.flakeModules.easyOverlay
      ];
      perSystem = { config, system, pkgs, ... }:
        let
          nodejs = pkgs.nodejs;

          mkWrapper = path:
            let
              ngserver = import path {
                inherit pkgs;
                inherit system;
                inherit nodejs;
              };
              inherit (ngserver) package nodeDependencies;
            in
            pkgs.writeShellApplication {
              name = "angular-language-server";
              runtimeInputs = [ package ];
              text = ''
                ngserver \
                  --ngProbeLocations "${nodeDependencies}/lib/node_modules" \
                  --tsProbeLocations "${nodeDependencies}/lib/node_modules" \
                  "$@"
              '';
            };

          v15 = mkWrapper ./packages/v15;
          v18 = mkWrapper ./packages/v18;
        in
        {
          overlayAttrs = {
            angular-language-server_15 = v15;
            angular-language-server_18 = v18;
            angular-language-server = v18;
          };
          packages = {
            angular-language-server_15 = v15;
            angular-language-server_18 = v18;
            default = v18;
          };
          devShells = {
            v15 = pkgs.mkShell {
              packages = [ nodejs v15 ];
            };
            v18 = pkgs.mkShell {
              packages = [ nodejs v18 ];
            };
            default = pkgs.mkShell {
              packages = [ nodejs v18 ];
            };
          };
        };
    };
}
