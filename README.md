# angular-language-server

## Usage

Add repo to flake input

```nix
inputs = {
    angular-language-server.url = github:csvenke/angular-language-server-flake;
};
```

Add the overlay

```nix
nixpkgs.overlays = [
  inputs.angular-language-server.overlays.default
];
```

Add the package

```nix
pkgs.mkShell {
    packages = [
        pkgs.angular-language-server
    ];
}
```
