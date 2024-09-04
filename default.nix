{ pkgs, system, nodejs }:

let
  ngserver = import ./ngserver {
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
}
