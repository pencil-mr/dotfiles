{ config, pkgs, ... }:

let
    unstable = import <nixos-unstable> { };
in {
    environment.systemPackages = with pkgs; [
    unstable.zig
    unstable.dune_3
    unstable.ocaml
    unstable.ocamlPackages.ocaml-lsp
    unstable.ocamlPackages.ocamlformat_0_25_1
    unstable.rust-analyzer-unwrapped
    unstable.rustc
    unstable.cargo
    ];
    environment.variables = rec {
    RUST_SRC_PATH = "${unstable.rust.packages.stable.rustPlatform.rustLibSrc}";
    };
}
