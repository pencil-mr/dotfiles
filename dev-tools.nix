{ config, pkgs, ... }:

let
    unstable = import <nixos-unstable> { };
in {
    environment.systemPackages = with pkgs; [
    unstable.rust-analyzer
    unstable.rustc
    unstable.cargo
    ];
    environment.variables = rec { 
	    RUST_SRC_PATH = "${unstable.rust.packages.stable.rustPlatform.rustLibSrc}";
    };
}
