Nix flake that provides `angular-language-server` not found in nixpkgs.

## Usage

### With nix profile

```bash
nix profile install github:csvenke/angular-language-server-flake
angular-language-server --stdio
```

### With nix run

```bash
nix run github:csvenke/angular-language-server-flake -- --stdio
```

### With nix develop

```bash
nix develop github:csvenke/angular-language-server-flake
angular-language-server --stdio
```

### With flake.nix

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    angular-language-server.url = "github:csvenke/angular-language-server-flake";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = { pkgs, system, ... }:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.angular-language-server.overlays.default
            ];
          };

          shell = pkgs.mkShell {
            packages = [
              pkgs.angular-language-server
            ];
          };
        in
        {
          devShells.default = shell;
        };
    };
}
```
