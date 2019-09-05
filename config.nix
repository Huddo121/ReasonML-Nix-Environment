rec {
    pkgs = import <nixpkgs> {};
    nodejs = pkgs.nodejs-10_x;
    myNodePackages = let np = import ./nix/bs-platform/default.nix { inherit pkgs nodejs; };
    in np // {
        bs-platform = np.bs-platform.override {
            # Fix paths so we can use a cached Ninja, instead of compiling it
            preRebuild = ''
                substituteInPlace ./scripts/install.js \
                    --replace "var ninja_bin_output = path.join(root_dir, 'lib', 'ninja.exe')" \
                            "var ninja_bin_output = '${pkgs.ninja}/bin/ninja'"

                substituteInPlace ./scripts/install.js --replace "function provideNinja" "function hideNinja"

                substituteInPlace ./scripts/install.js --replace "provideNinja" "//hideNinja"
            '';

            # This ensures we don't have to link node_modules into CWD.  Makes it
            # easier to use in nix-shell, or iteratively from ./result, etc
            postInstall = ''
            wrapProgram $out/bin/bsb --prefix npm_config_prefix : $out
            wrapProgram $out/bin/bsc --prefix npm_config_prefix : $out
            '';

            # Use cached ocaml compiler, instead of recompiling one
            buildInputs = with pkgs.ocamlPackages; np.bs-platform.buildInputs ++ [ ocaml merlin pkgs.makeWrapper ];
        };
    };
}