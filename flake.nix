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
          angular-language-server = import ./default.nix {
            inherit pkgs;
            inherit system;
            inherit nodejs;
          };
        in
        {
          overlayAttrs = {
            inherit angular-language-server;
          };
          packages = {
            default = angular-language-server;
          };
          devShells = {
            default = pkgs.mkShell {
              packages = [
                nodejs
                angular-language-server
              ];
            };
          };
        };
    };
}
