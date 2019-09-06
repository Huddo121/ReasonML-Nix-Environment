let
  config = import ./config.nix;
in
  with config;
  pkgs.mkShell {
      buildInputs = [ nodePackages.bs-platform nodejs ];
      shellHook = ''
        export PATH="`pwd`/node_modules/.bin:$PATH"
      '';
  }