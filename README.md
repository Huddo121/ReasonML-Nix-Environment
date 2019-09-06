# ReasonML-Nix-Environment
A nix environment for getting up and running with ReasonML.

It doesn't work...

Current state of affairs is that commands like `bsb -init` seem to run just fine, but actually trying to do anything
that invokes ninja is currently failing because it's looking for ninja under
`/nix/store/<hash>-node_bs-platform-5.0.6/lib/node_modules/bs-platform/lib/ninja.exe`. Unsure if where exactly this is
being picked up from.

## Steps taken
* `nix-shell -p nodejs nodePackages.node2nix`
* `echo "[ \"bs-platform\" ]" > node-packages.json`
* `node2nix --nodejs-10 -i node-packages.json`
* `mkdir nix/bs-platform -p`
* `mv *.nix nix/bs-platform`
* `touch config.nix default.nix`
* Fuck around a lot trying to get this working on NixOS
* https://discourse.nixos.org/t/bs-platform-install/1520/5 << Biggest hints so far