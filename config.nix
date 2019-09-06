rec {
    pkgs = import <nixpkgs> {};

    nodejs = pkgs.nodejs-10_x;

    # Bs-platform and ocaml compiler versions have to be synced
    ocamlVersion = "4.02.3";
    ocamlCompiler = pkgs.ocaml_4_02;

    nodePackages = let np = import ./nix/bs-platform/default.nix { inherit pkgs nodejs; };
    in np // {
        bs-platform = np.bs-platform.override {
            # Fix paths so we can use a cached Ninja, instead of compiling it
            preRebuild = ''
                substituteInPlace ./scripts/install.js \
                    --replace "var ninja_bin_output = path.join(root_dir, 'lib', 'ninja.exe')" \
                            "var ninja_bin_output = '${pkgs.ninja}/bin/ninja'"

                substituteInPlace ./scripts/install.js \
                    --replace "return version === vendor_ninja_version;" \
                              "return true;"
            '';

            # This ensures we don't have to link node_modules into CWD.  Makes it
            # easier to use in nix-shell, or iteratively from ./result, etc
            postInstall = ''
            wrapProgram $out/bin/bsb --prefix npm_config_prefix : $out
            wrapProgram $out/bin/bsc --prefix npm_config_prefix : $out
            '';

            # Use cached ocaml compiler, instead of recompiling one
            buildInputs = with pkgs.ocamlPackages; np.bs-platform.buildInputs ++ [ ocamlCompiler merlin pkgs.makeWrapper ];
        };
    };
}