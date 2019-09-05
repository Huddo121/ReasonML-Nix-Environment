
## Steps taken
* `nix-shell -p nodejs nodePackages.node2nix`
* `echo "[ \"bs-platform\" ]" > node-packages.json`
* `node2nix --nodejs-10 -i node-packages.json`
* `mkdir nix/bs-platform -p`
* `mv *.nix nix/bs-platform`
* `touch config.nix default.nix`
* Fuck around a lot trying to get this working on NixOS
* https://discourse.nixos.org/t/bs-platform-install/1520/5 << Biggest hints so far