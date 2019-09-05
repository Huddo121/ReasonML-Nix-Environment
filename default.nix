let
  config = import ./config.nix;
in
  with config;
  pkgs.mkShell {
      buildInputs = [ myNodePackages.bs-platform ];
      shellHook = ''
        export PATH="`pwd`/node_modules/.bin:$PATH"
      '';
  }