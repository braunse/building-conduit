{ sources ? import ./nix/sources.nix
, pkgs ? import sources.nixpkgs {}
, elixirVersion ? "elixir_1_11"
, erlangVersion ? "erlangR23"
, erlang ? pkgs.beam.packages.${erlangVersion}.erlang
, elixir ? pkgs.beam.packages.${erlangVersion}.${elixirVersion}
}:

pkgs.mkShell {
    buildInputs = [
        erlang
        elixir
    ];

    shellHook = ''
        export NIX_PATH=nixpkgs=${sources.nixpkgs}
    '';
}
